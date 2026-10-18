"""Count unique save calls, matched to tool results; inputs are read-only."""
import argparse,csv,json,re
from collections import Counter
from pathlib import Path
EXCLUDED={'atwine-2020','haney-2004','herrmann-2016'}
HERE=Path(__file__).resolve().parent

def extract(root):
    with (root/'kit-sonnet-5.5/rob2kit-domain-labels.csv').open(encoding='utf-8-sig') as f:
        slugs={r['slug'] for r in csv.DictReader(f)}-EXCLUDED
    assert len(slugs)==102,len(slugs)
    rows=[]
    for slug in sorted(slugs):
        files=sorted((root/'kit-sonnet-5.5/logs'/slug).glob('turn*.jsonl'))
        if not files: raise FileNotFoundError(f'No logs for {slug}')
        calls={};results={}
        for path in files:
            for line in path.open(encoding='utf8'):
                obj=json.loads(line);content=obj.get('message',{}).get('content',[])
                if not isinstance(content,list):continue
                for block in content:
                    if block.get('type')=='tool_use' and block.get('name','').endswith('save_domain_judgment'):
                        calls[block['id']]=(path.name,block.get('input',{}))
                    if block.get('type')=='tool_result':results[block['tool_use_id']]=block
        for tid,(file,args) in calls.items():
            assert tid in results,(slug,tid)
            result=results[tid];content=result.get('content','');body=content if isinstance(content,str) else json.dumps(content)
            failed=bool(result.get('is_error')) or bool(re.search(r'not saved|no assessment was submitted|"saved"\s*:\s*false|"isError"\s*:\s*true',body,re.I))
            reason='accepted'
            details=body.split('Complete answer syntax example')[0].strip()
            if failed:
                reason='evidence_or_basis_schema' if re.search(r'/bases|/evidence|evidence handle|bound evidence|basis|SourceQuoteReference',details,re.I) else 'other_validation'
            rows.append(dict(slug=slug,turn=file,tool_use_id=tid,status='rejected' if failed else 'accepted',reason=reason,result_excerpt=details if failed else ''))
        if slug=='banovic26-avatar-2024':
            failed_id='toolu_01CTHBEhdF5BAGdpapeh9D5F';retry_id='toolu_01PN3CESV3Hj5VbcRRWKbc5E'
            failed_basis=calls[failed_id][1]['answers'][0]['bases'][0]
            retry_basis=calls[retry_id][1]['answers'][0]['bases'][0]
            assert 'source_id' in failed_basis and 'evidence' not in failed_basis
            assert isinstance(retry_basis['evidence'],dict) and 'source_id' in retry_basis['evidence']
            assert results[failed_id].get('is_error') and not results[retry_id].get('is_error')
            receipt=dict(rejected_call=failed_id,rejected_basis=failed_basis,accepted_retry=retry_id,accepted_basis=retry_basis,
                         finding='Retry nested the source span under evidence; it did not send a literal eh_ handle string.')
            (HERE/'avatar-save-retry.json').write_text(json.dumps(receipt,indent=2)+'\n')
    return rows

def write_outputs(root):
    rows=extract(root)
    with (HERE/'save-rejections.csv').open('w',encoding='utf8',newline='') as f:
        w=csv.DictWriter(f,fieldnames=rows[0].keys());w.writeheader();w.writerows(rows)
    counts=Counter(r['reason'] for r in rows)
    summary=dict(trials=102,total_calls=len(rows),rejected=sum(r['status']=='rejected' for r in rows),by_reason=dict(counts),avatar_calls=sum(r['slug']=='banovic26-avatar-2024' for r in rows),avatar_rejected=sum(r['slug']=='banovic26-avatar-2024' and r['status']=='rejected' for r in rows))
    assert summary['avatar_calls']==7 and summary['avatar_rejected']==1
    (HERE/'save-rejections-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    return summary

def main():
    p=argparse.ArgumentParser();p.add_argument('--data-root',type=Path,required=True);args=p.parse_args()
    print(json.dumps(write_outputs(args.data_root),indent=2))

if __name__=='__main__':main()
