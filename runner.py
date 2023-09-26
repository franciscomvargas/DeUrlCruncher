import os
import time
import requests
import yaml
from yaml.loader import SafeLoader
import json
import subprocess
import time
from runner_utils.utils import *

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-mr", "--model_req", 
                    help="DeSOTA Request as yaml file path",
                    type=str)
parser.add_argument("-mru", "--model_res_url",
                    help="DeSOTA API Rsponse URL for model results",
                    type=str)

# :: os.getcwd() = C:\users\[user]\Desota\DeRunner
# WORKING_FOLDER = os.getcwd()
APP_PATH = os.path.dirname(os.path.realpath(__file__))
DESOTA_ROOT_PATH = "\\".join(APP_PATH.split("\\")[:-2])
USER_PATH = "\\".join(APP_PATH.split("\\")[:-3])

CONFIG_PATH = os.path.join(DESOTA_ROOT_PATH, "Configs")
USER_CONF_PATH = os.path.join(CONFIG_PATH, "user.config.yaml")
SERV_CONF_PATH = os.path.join(CONFIG_PATH, "services.config.yaml")
LAST_SERV_CONF_PATH = os.path.join(CONFIG_PATH, "latest_services_config.yaml")

# DeSOTA Funcs
def get_model_req(req_path):
    '''
    {
        "task_type": None,      # TASK VARS
        "task_model": None,
        "task_dep": None,
        "task_args": None,
        "task_id": None,
        "filename": None,       # FILE VARS
        "file_url": None,
        "text_prompt": None     # TXT VAR
    }
    '''
    if not os.path.isfile(req_path):
        exit(1)
    with open(req_path) as f:
        return yaml.load(f, Loader=SafeLoader)

#   > Grab User Configurations
def get_user_config() -> dict:
    if not os.path.isfile(USER_CONF_PATH):
        print(f" [USER_CONF] Not found-> {USER_CONF_PATH}")
        raise EnvironmentError()
    with open( USER_CONF_PATH ) as f_user:
        return yaml.load(f_user, Loader=SafeLoader)

#   > Return (services.config.yaml, latest_services.config.yaml)
def get_services_config() -> (dict, dict):
    if not (os.path.isfile(SERV_CONF_PATH) or os.path.isfile(LAST_SERV_CONF_PATH)):
        print(f" [SERV_CONF] Not found-> {SERV_CONF_PATH}")
        print(f" [LAST_SERV_CONF] Not found-> {LAST_SERV_CONF_PATH}")
        raise EnvironmentError()
    with open( SERV_CONF_PATH ) as f_curr:
        with open(LAST_SERV_CONF_PATH) as f_last:
            return yaml.load(f_curr, Loader=SafeLoader), yaml.load(f_last, Loader=SafeLoader)


def main(args):
    '''
    return codes:
    0 = SUCESS
    1 = INPUT ERROR
    2 = OUTPUT ERROR
    3 = API RESPONSE ERROR
    9 = REINSTALL MODEL (critical fail)
    '''

    #---INPUT---# TODO (PRO ARGS)
    _numresults = 10
    #---INPUT---#

    # Time when grabed
    start_time = int(time.time())

    # DeSOTA Model Request
    model_request_dict = get_model_req(args.model_req)
    
    # API Response URL
    send_task_url = args.model_res_url
    
    # TMP File Path
    out_filepath = os.path.join(APP_PATH, f"text-to-url{start_time}.json")
    
    # Get url from request
    _req_text = get_request_text(model_request_dict)
    with open(os.path.join(APP_PATH, "debug.txt"), "w") as fw:
        fw.writelines([
            f"INPUT: '{_req_text}'\n",
            f"IsINPUT?: {True if _req_text else False}\n"
        ])


    # Run Model
    if _req_text:
        user_conf = get_user_config()
        if user_conf["system"] == "win":
            # Model Vars
            serv_conf, last_serv_conf = get_services_config()
            _model_runner_param = serv_conf["services_params"]["franciscomvargas/deurlcruncher"]["win"]     # Model params from services.config.yaml
            _model_runner_py = os.path.join(USER_PATH, _model_runner_param["runner_py"])                    # Python with model runner packages
            _model_run = os.path.join(APP_PATH, "main.py")                                                  # Python with model runner packages
            
            _sproc = subprocess.Popen(
                [
                    _model_runner_py, _model_run, 
                    "--query", str(_req_text), 
                    "--numresults", str(_numresults),
                    "--respath", out_filepath
                ]
            )
            # TODO: implement model timeout
            while True:
                _ret_code = _sproc.poll()
                if _ret_code != None:
                    break
    else:
        print(f"[ ERROR ] -> DeUrlCruncher Request Failed: No Input found")
        exit(1)

    if not os.path.isfile(out_filepath):
        print(f"[ ERROR ] -> DeUrlCruncher Request Failed: No Output found")
        exit(2)
    
    with open(out_filepath, "r") as fr:
        deurlcruncher_res = json.loads(fr.read())
    
    with open(os.path.join(APP_PATH, "debug.txt"), "a") as fw:
        fw.write(f"RESULT: {json.dumps(deurlcruncher_res)}")

    print(f"[ INFO ] -> DeUrlCruncher Response:{json.dumps(deurlcruncher_res, indent=2)}")
    
    # DeSOTA API Response Preparation
    files = []
    with open(out_filepath, 'rb') as fr:
        files.append(('upload[]', fr))
        # DeSOTA API Response Post
        send_task = requests.post(url = send_task_url, files=files)
        print(f"[ INFO ] -> DeSOTA API Upload:{json.dumps(send_task.json(), indent=2)}")
    # Delete temporary file
    os.remove(out_filepath)

    if send_task.status_code != 200:
        print(f"[ ERROR ] -> DeUrlCruncher Post Failed (Info):\nfiles: {files}\nResponse Code: {send_task.status_code}")
        exit(3)
    
    print("TASK OK!")
    exit(0)


if __name__ == "__main__":
    args = parser.parse_args()
    if not args.model_req or not args.model_res_url:
        raise EnvironmentError()
    main(args)