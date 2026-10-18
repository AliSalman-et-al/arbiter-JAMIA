"""Regression fixtures proving each geometric failure mode trips the gate."""
import unittest
from build import Scene
from geometry import check


class GeometryChecks(unittest.TestCase):
    def test_clear_text_in_own_pill(self):
        scene=Scene();scene.pill(20,40,'Clear')
        self.assertTrue(check(scene)['passed'])

    def test_text_crossed_by_stroke(self):
        scene=Scene();scene.text(20,40,'Crossing');scene.line(15,36,90,36)
        self.assertTrue(any('text/stroke' in s for s in check(scene)['violations']))

    def test_nested_pills_are_not_layout_containers(self):
        scene=Scene();scene.rect(10,10,100,60,kind='pill');scene.rect(25,25,50,20,kind='pill')
        self.assertTrue(any('overlapping boxes' in s for s in check(scene)['violations']))

    def test_arrow_tip_near_glyph(self):
        scene=Scene();scene.text(20,40,'Target')
        right=scene.text_records[-1]['bbox'][2]
        scene.line(right+30,60,right+2,36,arrow=True)
        self.assertTrue(any('near text' in s for s in check(scene)['violations']))

    def test_arrow_penetrates_box(self):
        scene=Scene();scene.rect(200,10,60,60);scene.line(180,40,220,40,arrow=True)
        self.assertTrue(any('penetrates box' in s for s in check(scene)['violations']))

    def test_element_outside_frame(self):
        scene=Scene();scene.rect(690,10,20,20)
        self.assertTrue(any('outside frame' in s for s in check(scene)['violations']))

    def test_text_overlap(self):
        scene=Scene();scene.text(20,40,'One');scene.text(21,40,'Two')
        self.assertTrue(any('text/text' in s for s in check(scene)['violations']))

    def test_arrow_shaft_requires_one_mm_clearance(self):
        scene=Scene();scene.text(80,80,'Clearance')
        y=scene.text_records[-1]['bbox'][1]-3
        scene.line(20,y,180,y,arrow=True,sw=1)
        self.assertTrue(any('text/arrow clearance' in v for v in check(scene)['violations']))

    def test_arrow_shaft_at_one_mm_passes(self):
        scene=Scene();scene.text(80,80,'Clearance')
        y=scene.text_records[-1]['bbox'][1]-4.5
        scene.line(20,y,180,y,arrow=True,sw=1)
        self.assertTrue(check(scene)['passed'])

    def test_old_domain_stack_hits_flanking_arrows(self):
        scene=Scene();scene.text(476,180,'select_visual_evidence',10,'mono',anchor='middle')
        for x in (406,546):scene.line(x,126,x,194,arrow=True,sw=1)
        self.assertTrue(any('text/arrow clearance' in v for v in check(scene)['violations']))

    def test_old_report_connector_doubles_server_border(self):
        scene=Scene();scene.rect(12,196,672,60,sw=1.5)
        scene.line(616,260,340,260,sw=1,kind='connector')
        self.assertTrue(any('parallel to box border' in v for v in check(scene)['violations']))

    def test_vertical_connector_parallel_border(self):
        scene=Scene();scene.rect(20,20,80,80)
        scene.line(105,30,105,90,kind='connector')
        self.assertTrue(any('parallel to box border' in v for v in check(scene)['violations']))

    def test_parallel_connector_two_mm_clear_passes(self):
        scene=Scene();scene.rect(20,20,80,80)
        scene.line(30,109.9,90,109.9,kind='connector')
        self.assertTrue(check(scene)['passed'])

    def test_short_parallel_run_passes(self):
        scene=Scene();scene.rect(20,20,80,80)
        scene.line(30,105,50,105,kind='connector')
        self.assertTrue(check(scene)['passed'])

    def test_perpendicular_departure_passes(self):
        scene=Scene();scene.rect(20,20,80,80)
        scene.line(60,100,60,130,kind='connector')
        self.assertTrue(check(scene)['passed'])


if __name__=='__main__':unittest.main()
