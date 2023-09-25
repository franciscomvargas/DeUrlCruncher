
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
parser.add_argument("-nr", "--numresults", 
                    help='Quantity of results, default 10',
                    default=10,
                    type=int)
CURRENT_PATH = os.path.dirname(os.path.realpath(__file__))
DEFAULT_OUT_PATH = os.path.join(CURRENT_PATH, f"deurlcruncher_res{int(time.time())}.txt")
parser.add_argument("-rp", "--respath", 
                    help=f'Output text path, default `{DEFAULT_OUT_PATH}`',
                    default=str(DEFAULT_OUT_PATH),
                    type=str)


def get_urls(query, numresults=5):
    return list(search(query, num_results=numresults, timeout=4))

def main(args):
    if args.query == "deurlcruncher_cli":
        os.system("cls")
        print("Welcome to DeUrlCruncher CLI\n(Get list of URLs from search query)\n\t\t\t\t\tby DeSOTA 2023")

        while True:
            print("*"*80)
            _user_query = input("What Are you loocking for? ('exit' to exit)\n-------------------------------------------\n|")
            if _user_query in ["exit", "Exit", "EXIT"]:
                break
            print("-------------------------------------------")
            _numresults = input("How many results you need: ")

            
            
            url_res = get_urls(_user_query, int(_numresults)) if int(_numresults) else get_urls(_user_query)
            
            print(f"\nResult: {json.dumps(url_res, indent=2) if not isinstance(url_res, str) else url_res}")
    else:
        _url_res = get_urls(args.query, args.numresults)
        if _url_res:
            with open(args.respath, "w") as fw:
                fw.write(json.dumps(_url_res))
        exit(0)
        
if __name__ == "__main__":
    args = parser.parse_args()
    main(args)