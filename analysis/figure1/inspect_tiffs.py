"""Tile every 600-dpi TIFF at 4x final size (384 px/in at a 96-dpi view).

Run after build.py. PNG tiles are local inspection intermediates; the committed
manifest records exact crop bounds and the hashes of the TIFFs inspected.
"""
import hashlib
import json
import math
from pathlib import Path
from PIL import Image

HERE=Path(__file__).resolve().parent
OUT=HERE.parents[1]/'analysis/output/manuscript'
DEST=HERE/'.inspection'


def main():
    DEST.mkdir(exist_ok=True)
    figures=[]
    for name,path in [(f'Figure{n}',OUT/f'Figure{n}.tiff') for n in (1,2)]:
        image=Image.open(path).convert('RGB')
        source_size=image.size
        image=image.resize((round(image.width*384/600),round(image.height*384/600)),Image.Resampling.LANCZOS)
        cols=3;rows=math.ceil(image.height/900);tiles=[]
        for row in range(rows):
            for col in range(cols):
                bounds=(math.floor(col*image.width/cols),math.floor(row*image.height/rows),
                        math.ceil((col+1)*image.width/cols),math.ceil((row+1)*image.height/rows))
                file=DEST/f'{name}-r{row+1}c{col+1}.png'
                image.crop(bounds).save(file)
                tiles.append(dict(tile=file.name,bounds_384dpi=bounds))
        figures.append(dict(figure=name,tiff_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                            source_size_600dpi=source_size,rows=rows,columns=cols,tiles=tiles))
    (HERE/'visual-inspection.json').write_text(json.dumps(dict(source_dpi=600,inspection_dpi=384,
        magnification_at_96dpi=4,figures=figures),indent=2)+'\n')
    print(sum(len(f['tiles']) for f in figures),'tiles at 4x final size; see visual-inspection.json')


if __name__=='__main__':main()
