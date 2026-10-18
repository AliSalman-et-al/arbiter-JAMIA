from pathlib import Path
from playwright.sync_api import sync_playwright
import json
here=Path(__file__).resolve().parent
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True)
 page=browser.new_page(viewport={'width':780,'height':1000},device_scale_factor=2)
 page.goto((here/'html-report/relabelled/trials/banovic26-avatar-2024.html').as_uri());page.screenshot(path=str(here/'qa/avatar-html-report.png'))
 page.goto((here/'html-report/relabelled/index.html').as_uri())
 table=page.locator('.table-wrap');print(table.bounding_box());print(page.locator('table').bounding_box())
 table.screenshot(path=str(here/'qa/avatar-html-report-table.png'))
 page.set_viewport_size({'width':400,'height':900})
 page.goto((here/'html-report/relabelled/trials/banovic26-avatar-2024.html').as_uri())
 nav=page.locator('.domain-nav').bounding_box();pill=page.locator('#d1 .domain-head > .pill').bounding_box()
 clip=dict(x=20,y=nav['y'],width=360,height=pill['y']+pill['height']-nav['y']+8)
 page.screenshot(path=str(here/'qa/avatar-html-report-domain-view.png'),full_page=True,clip=clip)
 minimum=page.locator('.domain-nav *, #d1 .domain-head *').evaluate_all("els => Math.min(...els.filter(e => e.textContent.trim()).map(e => parseFloat(getComputedStyle(e).fontSize)))")
 assert minimum>=11.52
 (here/'qa/avatar-html-report-domain-view.json').write_text(json.dumps(dict(viewport_css_px=[400,900],device_scale_factor=2,clip_css_px=clip,min_font_css_px=minimum,browser=browser.version),indent=2)+'\n')
 print('Trial-page domain detail:',clip)
 browser.close()
