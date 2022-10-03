#!/usr/bin/env python

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import math
from argparse import ArgumentParser

def main():

    # Parse command line arguments
    args = cmdlineparse()
    
    # Get num_res
    num_res = int(args.num_res)
    resids = np.arange(1, num_res + 1, 1)
    n_rows = int(math.sqrt(num_res))
    n_cols = num_res / n_rows
    if num_res % n_rows > 0:
        n_cols +=1
    
    # Get offset for graphing
    if args.res_offset:
        res_offset = int(args.res_offset)
    else:
        res_offset = int(0)
    
    # Read in per-residue phi/psi angles assuming
    data = np.loadtxt(str(args.input_file),dtype="float",usecols=range(1,2 * num_res + 1))
    data = data.transpose()
    if args.input_file_native:
        native = np.loadtxt(str(args.input_file_native),dtype="float",usecols=range(1,2 * num_res + 1))
        native = native.transpose()
    if args.input_ref:
        input_ref = np.loadtxt(str(args.input_ref),dtype="float",usecols=range(0,6))
        input_ref = input_ref.transpose()
    if args.native_ref:
        native_ref = np.loadtxt(str(args.native_ref),dtype="float",usecols=range(0,6))
        native_ref = native_ref.transpose()

    # Plot histogram
    font = {'family' : 'monospace',
            'size' : int(args.font_size)}
    plt.rc('font',**font)
    plt.figure(0,figsize=(11,8.5))
    res_index = int(0)
    ax_scale = np.arange(-180.0, 210.0, 90.0)
    for p in range(0, num_res):
        plt.subplot(n_rows, n_cols, p + 1,xticks=ax_scale,yticks=ax_scale,xlim=(-180,180),ylim=(-180,180))
        label = str(resids[p] + res_offset)
        plt.xlabel(args.x_label[p])
        plt.ylabel(args.y_label[p])
        plt.scatter(data[res_index],data[res_index + 1], s=2,color="red",alpha=0.05)
        if args.input_file_native:
            plt.scatter(native[res_index],native[res_index + 1], s=2,color="blue",alpha=0.05)
        if args.input_ref:
            plt.scatter(input_ref[res_index],input_ref[res_index + 1],marker="*", s=2,color="darkred",alpha=0.05)
        if args.native_ref:
            plt.scatter(native_ref[res_index],native_ref[res_index + 1],marker="*" ,s=2,color="darkblue",alpha=0.05)
        res_index += 2
    plt.subplots_adjust(hspace=0.25, wspace=0.25)
    plt.savefig(args.output_file,bbox_inches='tight',dpi=600)

def cmdlineparse():
    parser = ArgumentParser(description="Command line options")
    parser.add_argument("-input_file",dest="input_file", required=True,help="Input file from CPPTRAJ rama calculation", metavar="input file")
    parser.add_argument("-input_file_native",dest="input_file_native", required=False,
                        help="Plot data from a second file from CPPTRAJ rama calculation with rows/columns/residues corresponding to the primary input file", metavar="input file native")
    parser.add_argument("-input_ref",dest="input_ref", required=False,help="Input file from CPPTRAJ rama calculation", metavar="input ref")
    parser.add_argument("-native_ref",dest="native_ref", required=False,help="Input file from CPPTRAJ rama calculation", metavar="native ref")
    parser.add_argument("-output_file",dest="output_file", required=True,help="Filename for the final figure",metavar="output file")
    parser.add_argument("-num_res",dest="num_res",required=True,help="Number of residues/plots for phi/psi plots", metavar="<num_res>")
    parser.add_argument("-res_offset",dest="res_offset",required=False,help="Label residue numebers correctly in plots by indicating offset from 1", metavar="<res_offset>")
    parser.add_argument("-font_size",dest="font_size",required=False,help="Text font size", default=int(12), metavar="<font_size>")
    parser.add_argument("-x_label",dest="x_label",required=False,help="X-label", nargs="+", metavar="<X-label>")
    parser.add_argument("-y_label",dest="y_label",required=False,help="Y-label", nargs="+", metavar="<Y-label>")
    args = parser.parse_args()
    return args

# From command-line only
if __name__ == '__main__':
    main()
