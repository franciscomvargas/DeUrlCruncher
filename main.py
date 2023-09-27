
from googlesearch import search
import json
import os
import time
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-q", "--query", 
                    help='Search query, empty to enter in cli mode',
                    default="deurlcruncher_cli",
                    type=str)
parser.add_argument("-rn", "--resnum", 
                    help='Quantity of results',
                    default=10,
                    type=int)
CURRENT_PATH = os.path.dirname(os.path.realpath(__file__))
DEFAULT_OUT_PATH = os.path.join(CURRENT_PATH, f"deurlcruncher_res{int(time.time())}.txt")
parser.add_argument("-rp", "--respath", 
                    help=f'Output json file path, default `{DEFAULT_OUT_PATH}`',
                    default=str(DEFAULT_OUT_PATH),
                    type=str)
                
# UTILS
def pcol(obj, template, nostart=False, noend=False):
    '''
    # Description
        print with colors
    # Arguments
    {
        obj: {
            desc: object to print, parsed into string
        },
        template: {
            desc: template name,
            options: [
                header1,
                header2,
                section,
                title,
                body,
                sucess,
                fail
            ]
        }
    }
    '''
    _configs = {
        "header1": "\033[1;105m",
        "header2": "\033[1;95m",
        "search": "\033[104m",
        "section": "\033[94m",
        "title": "\033[7m",
        "body": "\033[97m",
        "sucess": "\033[92m",
        "fail": "\033[91m",
        "end": "\033[0m"
    }
    _morfed_obj = ""
    # PARSE OBJ INTO STR
    if isinstance(obj, list) or isinstance(obj, dict):
        _morfed_obj = json.dumps(obj, indent=2)
    elif not isinstance(obj, str):
        try:
            _morfed_obj = str(obj)
        except:
            # Last ressource
            pass
    else:
        _morfed_obj = obj

    if template in _configs and (_morfed_obj or _morfed_obj==""):
        return f"{_configs[template] if not nostart else ''}{_morfed_obj}{_configs['end'] if not noend else ''}"
    else:
        return obj

def get_urls(query, resnum=5):
    return list(search(query, num_results=resnum, timeout=4))

def main(args):
    if args.query == "deurlcruncher_cli":
        os.system("cls")
        print(pcol("Welcome to DeUrlCruncher CLI ", "header1"), pcol("by © DeSOTA, 2023", "header2"))
        print(pcol("Get list of URLs from search query\n", "body"))

        while True:
            print(pcol("*"*80, "body"))

            # Get User Query
            _user_query = ""
            _exit = False
            try:
                _input_query_msg = "".join([pcol("What Are you loocking for? ('exit' to exit)\n-------------------------------------------\n|", "search"), pcol("", "title", noend=True)])
                _user_query = input(_input_query_msg)
            except KeyboardInterrupt:
                _exit = True
                pass
            if _user_query in ["exit", "Exit", "EXIT"] or _exit:
                print(pcol("", "title", nostart=True))
                break
            print(f'{pcol("", "title", nostart=True)}{pcol("-------------------------------------------", "search")}')


            # Get Number of Results
            _resnum = input(pcol("Qtty of results (default=5, min=1, max=20): ", "section"))
            if not _resnum.isnumeric() or int(_resnum)<=0 or int(_resnum)>20:
                _resnum=5
            else:
                _resnum = int(_resnum)
            
            
            # Get Results
            url_res = get_urls(_user_query, _resnum) if _resnum else get_urls(_user_query)
            if len(url_res) > _resnum:
                url_res = url_res[:_resnum]

            # Print Results
            print(pcol(f"\nResult: {json.dumps(url_res, indent=2) if not isinstance(url_res, str) else url_res}\n", "sucess"))
    else:
        _url_res = get_urls(args.query, args.resnum)
        if _url_res:
            with open(args.respath, "w") as fw:
                fw.write(json.dumps(_url_res))
        exit(0)
        
if __name__ == "__main__":
    args = parser.parse_args()
    main(args)