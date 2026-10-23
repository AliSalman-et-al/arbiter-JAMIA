"""Shared publication metadata read by HTML and Word assembly."""
import re

ALT_DEFAULTS = [
'Architecture separating model interpretation from software source storage, evidence binding and executable RoB 2 decisions. The retained record supports reviewer inspection.',
'Illustrative AVATAR assessment linking trial-result judgments, answers and source evidence; the case explains the workflow and is not a representative performance sample.',
'Paired evaluation of 102 trials and 510 cells against two independent experts. A separate conditional branch contains 80 arm-discordant cells, 60 agreed choices and 20 splits.',
'Exact agreement and paired gains against each expert, pooled and by domain. Both pooled gains favor ARBITER; D5 gains are largest and D3 depends strongly on the expert reference. The full-cohort Published comparison is shown separately.',
'Paired signalling-answer differences by domain and expert, separating five-level and collapsed coding. D3 changes direction with coding against Expert 1; D5 collapsed gains are smaller against Expert 2.']


def main_legends(text):
    text = re.split(r'(?m)^eFigure 1[ .]', text, maxsplit=1)[0]
    starts = list(re.finditer(r'(?m)^(?:\*\*)?Figure ([1-5])[ .]', text))
    if [int(m[1]) for m in starts] != list(range(1, 6)):
        raise ValueError('Expected exactly five ordered main figure legends.')
    result = []
    for j, match in enumerate(starts):
        block = text[match.start():starts[j+1].start() if j+1 < len(starts) else len(text)].replace('**', '').strip()
        caption, separator, alt = block.partition('Alt text:')
        result.append((caption.strip(), alt.strip() if separator else ALT_DEFAULTS[j]))
    return result
