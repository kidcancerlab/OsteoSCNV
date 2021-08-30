#!/usr/bin/env python3

# Author: Dr Simone Zaccaria
# Website: https://simozacca.github.io/
# Old affilliation: Princeton University, NJ (USA)
# New affilliation: UCL Cancer Institute, London (UK)
# Correspondence: s.zaccaria@ucl.ac.uk

import os, sys, glob, re
from os.path import *
from collections import defaultdict
from collections import Counter
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns
import scipy
from scipy import stats
from itertools import combinations
plt.style.use('ggplot')
sns.set_style("whitegrid")
plt.rcParams["axes.grid"] = True
plt.rcParams["axes.edgecolor"] = "k"
plt.rcParams["axes.linewidth"]  = 1.5

argmax = (lambda D : max(D.keys(), key=(lambda x : D[x])))
argmin = (lambda D : min(D.keys(), key=(lambda x : D[x])))


def read_data(f):
    read = defaultdict(lambda : dict())
    form = (lambda p : ((p[0], int(p[1]), int(p[2])), p[3], (tuple(map(int, p[11].split('|'))), tuple(map(int, p[12].split('|'))))))
    with open(f, 'r') as i:
        for l in (g for g in i if len(g) > 1 and g[0] != '#'):
            g, e, h = form(l.strip().split())
            read[g][e] = h
    return dict(read)


def read_clones(f):
    form = (lambda p : (p[0], p[2]) if p[2] != 'None' else None)
    with open(f, 'r') as i:
        return dict(filter(lambda x : x is not None, [form(l.strip().split()) for l in i if len(l) > 1 and l[0] != '#']))


def get_data():
    hfiles = ['data/OS-10/calls.tsv',\
            'data/OS-17/calls.tsv',\
            'data/OS-8/calls.tsv',\
            'data/OS-11/calls.tsv',\
            'data/OS-47/OS-4-tib/calls.tsv',\
            'data/OS-47/OS-7-tib/calls.tsv',\
            'data/OS-47/OS-7-flank/calls.tsv',
            'data/OS-1315/OS-113/calls.tsv',
            'data/OS-1416/OS-114/calls.tsv',
            'data/OS-1416/OS-116/calls.tsv']
    assert all(os.path.isfile(f) for f in hfiles)

    cfiles = ['data/OS-10/mapping.tsv',\
            'data/OS-17/mapping.tsv',\
            'data/OS-8/mapping.tsv',\
            'data/OS-11/mapping.tsv',\
            'data/OS-47/OS-4-tib/mapping.tsv',\
            'data/OS-47/OS-7-tib/mapping.tsv',\
            'data/OS-47/OS-7-flank/mapping.tsv',
            'data/OS-1315/OS-113/mapping.tsv',
            'data/OS-1416/OS-114/mapping.tsv',
            'data/OS-1416/OS-116/mapping.tsv']
    assert all(os.path.isfile(f) for f in cfiles)

    iswgd = {}
    iswgd['OS-10'] = False
    iswgd['OS-17'] = True
    iswgd['OS-8'] = True
    iswgd['OS-11'] = True
    iswgd['OS-4-tib'] = False
    iswgd['OS-7-tib'] = False
    iswgd['OS-7-flank'] = False
    iswgd['OS-113'] = True
    iswgd['OS-114'] = True
    iswgd['OS-116'] = True

    data = {f.split('/')[-2] : read_data(f) for f in hfiles}
    clones = {f.split('/')[-2] : read_clones(f) for f in cfiles}    

    return data, clones, iswgd
