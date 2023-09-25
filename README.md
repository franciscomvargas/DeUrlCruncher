# DeUrlCruncher
Get google URL results from string query

<video src="Assets/readme_files/take_a_peek-deurlcruncher.mp4" controls title="Title"></video>

<details open>
    <summary><h1>Instalation</h1></summary>

* If model allready installed this installer function as upgrade, since the the installer webrequest newest installer from github - Take a look into [Installer Optional Arguments](#installer-optional-arguments)
* Install python if not exist
* Download miniconda and git as portables to Desota Folder
* Clone GitHub Repository
* Create a virtual environment with miniconda

<details open>
    <summary><h2>Use DeSOTA official <a href="https://github.com/DeSOTAai/DeManagerTools/blob/main/README.md">Manager Tools</a></h2></summary>

1. [![Install DeManagerTools](https://img.shields.io/static/v1?label=Desota%20-%20Manager%20Tools&message=Install&color=blue&logo=windows)](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/DeSOTAai/DeManagerTools/blob/main/executables/Windows/demanagertools.install.bat)

<!-- TODO: Convert desota host into HTTPS -->
<!-- [![Install DeManagerTools](https://img.shields.io/static/v1?label=Desota%20-%20Manager%20Tools&message=Install&color=blue&logo=windows)](http://129.152.27.36/assistant/download.php?system=win&file=demanagertools) -->

2. **Uncompress** File
3. **Run** .BAT file
4. **Open** [`Models Instalation`](https://github.com/DeSOTAai/DeManagerTools/#install--upgrade-services) tab
5. **Select** the Available Model `franciscomvargas\deurlcruncher`
6. **Press** `Start Instalation`

</details>

<details open>
    <summary><h2>Manual Windows Instalation</h2></summary>

* Go to CMD as Administrator (command prompt):
    * <kbd>⊞ Win</kbd> + <kbd>R</kbd>
    * Search: `cmd` 
    * <kbd>Ctrl</kbd> + <kbd>⇧ Shift</kbd> + <kbd>↵ Enter</kbd>

* Copy-Paste the following comands: 
    ```cmd
    powershell -command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/franciscomvargas/DeUrlCruncher/main/executables/Windows/deurlcruncher.install.bat -OutFile ~\deurlcruncher_installer.bat" && call %UserProfile%\deurlcruncher_installer.bat && del %UserProfile%\deurlcruncher_installer.bat

    ```
### Installer Optional Arguments

<table>
    <thead>
        <tr>
            <th>arg</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=3>/reinstall</td>
            <td>Overwrite project when re-installing</td>
        </tr>
        <tr>
            <td>Delete project service when re-installing</td>
        </tr>
        <tr>
            <td>Install without requiring user interaction</td>
        </tr>
    </tbody>
</table>

* Comand (Install with overwrite permission):

```cmd
powershell -command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/franciscomvargas/DeUrlCruncher/main/executables/Windows/deurlcruncher.install.bat -OutFile ~\deurlcruncher_installer.bat" && call %UserProfile%\deurlcruncher_installer.bat /reinstall && del %UserProfile%\deurlcruncher_installer.bat

```
    
    
</details>
</details>

<details open>
    <summary><h1>Operations</h1></summary>

<details open>
  <summary><h2>Open CLI (Command Line Interface) with DeSOTA - Manager Tools</h2></summary>

1. **Open** [`Models Dashboard`](https://github.com/DeSOTAai/DeManagerTools/#models-dashboard) tab
2. **Select** the model `franciscomvargas\deurlcruncher`
3. **Press** `Take a Peek`

</details>

<details open>
    <summary><h2>Manual Windows Operations</h3></summary>

* Go to CMD (command prompt):
  * <kbd>⊞ Win</kbd> + <kbd>R</kbd>
  * Search: `cmd` 
  * <kbd>Ctrl</kbd> + <kbd>⇧ Shift</kbd> + <kbd>↵ Enter</kbd>

<details open>
  <summary><h3>Open CLI (Command Line Interface)</h3></summary>

* Copy-Paste the following comands: 
    ```cmd
    %UserProfile%\Desota\Desota_Models\DeUrlCruncher\env\python %UserProfile%\Desota\Desota_Models\DeUrlCruncher\main.py

    ```

<details open>
  <summary><h3>Direct comand request</h3></summary>

#### DeUrlCruncher Arguments

<table>
    <thead>
        <tr>
            <th>short arg</th>
            <th>full arg</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>-q</code></td>
            <td><code>--query</code></td>
            <td>Search query, empty to enter in cli mode</td>
        </tr>
        <tr>
            <td><code>-nr</code></td>
            <td><code>--numresults</code></td>
            <td>Quantity of URL results, default <code>10</code></td>
        </tr>
        <tr>
            <td rowspan=2><code>-rp</code></td>
            <td rowspan=2><code>--respath</code></td>
            <td>Result json file path, default <code>DEFAULT_OUT_PATH</code></td>
        </tr>
        <tr>
            <td><code>DEFAULT_OUT_PATH</code>: %UserProfile%\Desota\Desota_Models\DeUrlCruncher\<code>f"deurlcruncher_res{int(time.time())}.json"</code></td>
        </tr>
    </tbody>
</table>

* Example: 
    ```cmd
    %UserProfile%\Desota\Desota_Models\DeUrlCruncher\env\python %UserProfile%\Desota\Desota_Models\DeUrlCruncher\main.py --query "turn coffee into software" --numresults 25 --respath %UserProfile%\desktop\duc_tmp_res.json && notepad %UserProfile%\desktop\duc_tmp_res.json

    ```
</details>
</details>
</details>
</details>

<details open>
    <summary><h1>Uninstalation</h1></summary>

<details open>
  <summary><h2>Use DeSOTA - Manager Tools</h2></summary>

1. **Open** [`Models Dashboard`](https://github.com/DeSOTAai/DeManagerTools/#models-dashboard) tab
2. **Select** the model `franciscomvargas\deurlcruncher`
3. **Press** `Uninstall`

<details open>
    <summary><h2>Manual Windows Uninstalation</h2></summary>

* Go to CMD (command prompt):
  * <kbd>⊞ Win</kbd> + <kbd>R</kbd>
  * Search: `cmd` 
  * <kbd>Ctrl</kbd> + <kbd>⇧ Shift</kbd> + <kbd>↵ Enter</kbd>

* Copy-Paste the following comands: 
    ```cmd
    %UserProfile%\Desota\DeRunner\executables\Windows\derunner.uninstall.bat

    ```
    * Uninstaller Optional `Arguments`

        |arg|Description|
        |---|---|
        |/Q|Uninstall without requiring user interaction|
        
        `Uninstall Quietly`
        
        ```cmd
        %UserProfile%\Desota\Desota_Models\NeuralQA\neuralqa\executables\Windows\neuralqa.uninstall.bat /Q

        ```
      
</details>
</details>

