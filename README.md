# DeUrlCruncher
Get google URL results from string query

https://github.com/franciscomvargas/DeUrlCruncher/assets/87917356/6fca9cc3-2320-4d34-b603-e9160da129dc


<details open>
    <summary><h1>Instalation</h1></summary>

## Use DeSOTA official [Manager & Tools](https://github.com/DeSOTAai/DeManagerTools#instalation)

1. [![Install DeManagerTools](https://img.shields.io/static/v1?label=Desota%20-%20Manager%20Tools&message=Install&color=blue&logo=windows)](https://github.com/DeSOTAai/DeManagerTools/releases/download/v0.0.2/dmt_installer-v0.0.2-win64.zip)

<!--
TODO
[![Install DeManagerTools](https://img.shields.io/static/v1?label=Desota%20-%20Manager%20Tools&message=Install&color=blue&logo=windows)](https://desota.net/assistant/download.php?file=demanagertools&system=win)
-->

2. **Open** [`Models Instalation`](https://github.com/DeSOTAai/DeManagerTools/#install--upgrade-desota-models-and-tools) tab

3. **Select** the Available Tool `franciscomvargas\deurlcruncher`

4. **Press** `Start Instalation`

<details>
    <summary><h2>Manual Windows Instalation</h2></summary>

* Go to CMD (command prompt):
    * <kbd>⊞ Win</kbd> + <kbd>R</kbd>
    * Search: `cmd` 


1. Create Model Folder:
```cmd
mkdir %UserProfile%\Desota\Desota_Models\DeUrlCruncher

```

2. Download Last Release:
```cmd
powershell -command "Invoke-WebRequest -Uri https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip -OutFile %UserProfile%\DeUrlCruncher_release.zip" 

```

3. Uncompress Release:
```cmd
tar -xzvf %UserProfile%\DeUrlCruncher_release.zip -C %UserProfile%\Desota\Desota_Models\DeUrlCruncher --strip-components 1 

```

4. Delete Compressed Release:
```cmd
del %UserProfile%\DeUrlCruncher_release.zip

```


### Setup:

5. Setup:
```cmd
%UserProfile%\Desota\Desota_Models\DeUrlCruncher\executables\Windows\deurlcruncher.setup.bat /debug

```

*  Optional Arguments:
    <table>
        <thead>
            <tr>
                <th>arg</th>
                <th>Description</th>
                <th>Example</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>/debug</td>
                <td>Echo ON setup commands</td>
                <td><code>%UserProfile%\Desota\Desota_Models\DeUrlCruncher\executables\Windows\deurlcruncher.setup.bat /debug</code></td>
            </tr>
        </tbody>
    </table>
    
    
</details>
</details>

<details open>
    <summary><h1>Operations</h1></summary>

<details open>
  <summary><h2>Open CLI (Command Line Interface) with DeSOTA - Manager Tools</h2></summary>

1. **Open** [`Models Dashboard`](https://github.com/DeSOTAai/DeManagerTools/#models--tools-dashboard) tab

2. **Select** the model `franciscomvargas\deurlcruncher`

3. **Press** `Take a Peek`

    ![DeUrlCruncher_CLI](https://github.com/franciscomvargas/DeUrlCruncher/assets/87917356/593b47ed-39cf-4303-9151-a36aeb0c0e09)


</details>

<details open>
    <summary><h2>Manual Windows Operations</h3></summary>

* Go to CMD (command prompt):
  * <kbd>⊞ Win</kbd> + <kbd>R</kbd>
  * Enter: `cmd` 

<details open>
  <summary><h3>Open CLI (Command Line Interface)</h3></summary>

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
            <td rowspan=2><code>-rn</code></td>
            <td rowspan=2><code>--resnum</code></td>
            <td>Quantity of URL results</td>
        </tr>
        <tr>
            <td><i>default:</i> <code>10</code></code></td>
        </tr>
        <tr>
            <td rowspan=2><code>-rp</code></td>
            <td rowspan=2><code>--respath</code></td>
            <td>Output json file path</td>
        </tr>
        <tr>
            <td><i>default:</i> <code>%UserProfile%</code>\Desota\Desota_Models\DeUrlCruncher\deurlcruncher_res<code>[current_epoch]</code>.json</td>
        </tr>
    </tbody>
</table>

* Example: 
    ```cmd
    %UserProfile%\Desota\Desota_Models\DeUrlCruncher\env\python %UserProfile%\Desota\Desota_Models\DeUrlCruncher\main.py --query "turn coffee into code" --resnum 25 --respath %UserProfile%\desktop\duc_tmp_res.json && notepad %UserProfile%\desktop\duc_tmp_res.json

    ```
</details>
</details>
</details>
</details>

<details open>
    <summary><h1>Uninstalation</h1></summary>

## Use DeSOTA official Manager & Tools

1. **Open** [`Models Dashboard`](https://github.com/DeSOTAai/DeManagerTools/#models--tools-dashboard) tab

2. **Select** the model `franciscomvargas\deurlcruncher`

3. **Press** `Uninstall`

<details>
    <summary><h2>Manual Windows Uninstalation</h2></summary>

* Go to CMD (command prompt):
  * <kbd>⊞ Win</kbd> + <kbd>R</kbd>
  * Enter: `cmd` 

```cmd
%UserProfile%\Desota\Desota_Models\DeUrlCruncher\executables\Windows\deurlcruncher.uninstall.bat

```

* Optional `Arguments`

    |arg|Description|Example
    |---|---|---|
    |/Q|Uninstall without requiring user interaction|`%UserProfile%\Desota\Desota_Models\DeUrlCruncher\executables\Windows\deurlcruncher.uninstall.bat /Q`
      
</details>
</details>

