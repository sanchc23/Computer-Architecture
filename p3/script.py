import os

def main():
    for file in os.listdir():
        if (file.endswith("tb.sv") or file.endswith("testbench.v") or file.endswith("memory.v")):
            continue
        if file.endswith(".sv"):
            os.system("java Vcheck " + file)
        if file.endswith(".v"):
            os.system("java Vcheck " + file)
    

if __name__ == "__main__":
   main()