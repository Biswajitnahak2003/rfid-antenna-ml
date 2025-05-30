# 📡 ML-Optimized RFID Patch Antenna using Octave and openEMS

A simulation-based project to design and optimize a rectangular microstrip RFID antenna using computational electromagnetic tools (openEMS + Octave) and Machine Learning. The antenna’s performance metrics like return loss (S11), VSWR, directivity, input impedance, and efficiency are improved through ML-guided parameter optimization.

---

## 🎯 Objective

To design, simulate, and optimize an RFID patch antenna by:
- Sweeping antenna parameters (length, width, substrate thickness)
- Generating a dataset using Octave + openEMS
- Training a Machine Learning model to predict optimal parameters
- Simulating the ML-optimized antenna and evaluating its performance

---

## 🛠️ Technologies Used

- **Simulation Tools:** Octave, openEMS
- **Scripting:** Python (pandas, sklearn)
- **Visualization:** MATLAB-style plots, CSV data analysis
- **Other:** Git, VS Code

---

## 🧪 Project Files

| File/Folder                         | Description                                         |
|-------------------------------------|-----------------------------------------------------|
| `run_patch_batch.m`                | Runs multiple patch simulations and collects data   |
| `simulate_ml_optimized_antenna.m` | Simulates patch antenna using ML-optimized values   |
| `antenna_dataset_full.xlsx`        | Dataset of parameters vs results (S11, VSWR, etc.)  |
| `finding_best_param_by_ml.py`      | ML script to predict best geometry from dataset     |
| `merging_to_a_csv.py`              | Merges all simulation results into a training CSV   |
| `result_AND_plots/`                | Simulation results, S11 plots, antenna layout, etc. |
| `ML_Optimized_RFID_Antenna_Report.pdf` | Final report detailing methodology and results |

---

## 📈 Sample Outputs (From `result_AND_plots/`)

- 📉 S11 vs Frequency Plot
- 📐 Antenna layout preview from openEMS
- 🔍 VSWR and Input Impedance plots
- 🧠 ML prediction of optimal patch dimensions

---

## 📖 Full Report

A detailed write-up is included here:  
👉 [ML_Optimized_RFID_Antenna_Report.pdf](ML_Optimized_RFID_Antenna_Report.pdf)

Includes background theory, objective, simulation methodology, ML modeling, and performance comparison.

---

## 🙋‍♂️ Author

**Biswajit Nahak**  
B.Tech - Electronics and Telecommunication Engineering  
International Institute of Information Technology, Bhubaneswar  
📧 biswajitnahak2003@gmail.com  
🔗 [GitHub](https://github.com/Biswajitnahak2003)

---

## 📬 Contact & Collaboration

For project collaboration, optimization advice, or academic queries, feel free to open an issue or connect on GitHub.

