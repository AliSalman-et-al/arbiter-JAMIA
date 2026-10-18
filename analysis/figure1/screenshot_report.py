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
 print(page.locator('table').inner_text())
 browser.close()
