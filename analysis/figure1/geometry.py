"""Geometric QA on the actual SVG shapes and font-outline text extents.

Units are quarter millimetres. Curves are flattened at <=0.15-unit intervals;
clearance checks include half the stroke width. Nested layout containers are
allowed, but their borders must still clear every glyph bounding box.
"""
import math
import re
import xml.etree.ElementTree as ET
from shapely.geometry import box, Point, LineString, Polygon
from shapely.affinity import translate
from svgpathtools import parse_path


def check(scene):
    shapes=[]
    def visit(element,dy=0):
        if element.tag.split('}')[-1]=='defs': return  # paint definitions are not scene obstacles
        if 'aria-label' in element.attrib: return  # glyph paths belong to text
        transform=element.get('transform','')
        match=re.fullmatch(r'translate\(0 (-?[\d.]+)\)',transform)
        if match: dy+=float(match[1])
        tag=element.tag.split('}')[-1];a=element.attrib
        geom=None;closed=False
        if tag=='rect' and '%' not in a.get('width',''):
            x,y,w,h=[float(a.get(k,0)) for k in ('x','y','width','height')]
            r=min(float(a.get('rx',0)),w/2,h/2)
            geom=box(x+r,y+r,x+w-r,y+h-r).buffer(r,quad_segs=32) if r else box(x,y,x+w,y+h)
            closed=True
        elif tag=='circle':
            geom=Point(float(a['cx']),float(a['cy'])).buffer(float(a['r']),quad_segs=64);closed=True
        elif tag=='polygon':
            nums=[float(n) for n in re.findall(r'-?[\d.]+',a['points'])]
            geom=Polygon(list(zip(nums[::2],nums[1::2])));closed=True
        elif tag=='path':
            path=parse_path(a['d']);points=[]
            for segment in path:
                steps=max(2,math.ceil(segment.length()/0.15))
                points.extend((segment.point(i/steps).real,segment.point(i/steps).imag) for i in range(steps+1))
            if points:
                closed=path.isclosed()
                geom=Polygon(points) if closed else LineString(points)
        if geom is not None:
            geom=translate(geom,yoff=dy)
            sw=float(a.get('stroke-width',1)) if a.get('stroke','none')!='none' else 0
            stroke=geom.boundary.buffer(sw/2) if closed and sw else (geom.buffer(sw/2) if sw else None)
            # Solid arrowheads are obstacles too.
            if tag=='polygon': stroke=geom
            shapes.append(dict(id=len(shapes),tag=tag,geom=geom,stroke=stroke,closed=closed,sw=sw,kind=a.get('data-kind','container')))
        for child in element:visit(child,dy)
    visit(ET.fromstring(scene.svg()))
    texts=[(r,box(*r['bbox'])) for r in scene.text_records]
    issues=[];counts=dict(text_stroke_pairs=0,box_pairs=0,arrow_text_pairs=0,arrow_box_pairs=0,frame_elements=0,text_pairs=0)
    min_stroke_clearance=float("inf");min_tip_clearance=float("inf")
    for r,t in texts:
        for sh in shapes:
            if sh['stroke'] is None:continue
            counts['text_stroke_pairs']+=1
            distance=t.distance(sh['stroke'])
            min_stroke_clearance=min(min_stroke_clearance,distance)
            if distance<1.2-1e-5:
                issues.append(f"text/stroke {r['text']!r} vs {sh['id']} {sh['tag']}: {distance/4:.3f} mm")
    containers=[sh for sh in shapes if sh['closed'] and sh['tag'] in ('rect','circle')]
    for i,a in enumerate(containers):
        for b in containers[i+1:]:
            counts['box_pairs']+=1
            # Rows, lanes and source cards intentionally enclose their contents.
            if (a['kind']=='container' and a['geom'].contains(b['geom'])) or (b['kind']=='container' and b['geom'].contains(a['geom'])):continue
            if a['geom'].buffer(a['sw']/2+.6).intersects(b['geom'].buffer(b['sw']/2+.6)):
                issues.append(f"overlapping boxes {a['id']}/{b['id']}")
    for tip in scene.arrow_tips:
        point=Point(tip)
        for r,t in texts:
            counts['arrow_text_pairs']+=1
            min_tip_clearance=min(min_tip_clearance,point.distance(t))
            if point.distance(t)<3.2-1e-5:issues.append(f"arrow tip {tip} near text {r['text']!r}: {point.distance(t)/4:.3f} mm")
        for sh in containers:
            counts['arrow_box_pairs']+=1
            # Termination on a border is intentional; enclosing lanes/cards are
            # permitted only if the entire arrow remains in that container.
            if sh['geom'].contains(point) and point.distance(sh['geom'].boundary)>1.2:
                # Find its arrowhead and leader; enclosing scene containers are
                # valid only when they enclose both ends of the leader.
                leaders=[v for v in shapes if v['tag']=='path' and not v['closed'] and Point(v['geom'].coords[-1]).distance(point)<6.1]
                if not leaders or any(not sh['geom'].covers(v['geom']) for v in leaders):
                    issues.append(f"arrow tip {tip} penetrates box {sh['id']}")
    for i,(r,t) in enumerate(texts):
        for q,u in texts[i+1:]:
            counts['text_pairs']+=1
            if t.intersects(u):issues.append(f"text/text {r['text']!r} / {q['text']!r}")
    frame=box(0,0,696,scene.height)
    for label,g in [(r['text'],t) for r,t in texts]+[(str(v['id']),v['geom'].buffer(v['sw']/2)) for v in shapes]:
        counts['frame_elements']+=1
        if not frame.covers(g):issues.append(f"outside frame: {label}")
    return dict(passed=not issues,clearance_mm=.3,arrow_tip_clearance_mm=.8,curve_sampling_max_mm=.0375,
                minimum_text_stroke_clearance_mm=round(min_stroke_clearance/4,4) if math.isfinite(min_stroke_clearance) else None,
                minimum_arrow_text_clearance_mm=round(min_tip_clearance/4,4) if math.isfinite(min_tip_clearance) else None,
                text_elements=len(texts),shape_elements=len(shapes),arrow_tips=len(scene.arrow_tips),checks=counts,violations=issues)
