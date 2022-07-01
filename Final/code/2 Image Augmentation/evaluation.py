import pandas as pd
import mysql.connector
import sys
import numpy as np
from PIL import Image, ImageOps
import time
import random
from stored_fn import h_shift_fn, v_shift_fn, corp_fn, h_flip_fn, v_flip_fn

#==========================================#
#=============function & query=============#
#==========================================#
#python
def execute1(c, q, p):
    q_ = "SELECT width, height FROM picture WHERE idx=%s"
    c.execute(q_, (p[-1],))
    record = c.fetchone()
    w = record[0]
    h = record[1]
    
    c.execute(q, p)
    record = c.fetchone()
#mySQL
h_shift_query = "SELECT h_shift(pic, width, height, %s) FROM picture WHERE idx=%s"
v_shift_query = "SELECT v_shift(pic, width, height, %s) FROM picture WHERE idx=%s"
corp_query = "SELECT corp(pic, width, height, %s, %s, %s, %s) FROM picture WHERE idx=%s"
h_flip_query = "SELECT h_flip(pic, width, height) FROM picture WHERE idx=%s"
v_flip_query = "SELECT v_flip(pic, width, height) FROM picture WHERE idx=%s"

#==============================#
#=============main=============#
#==============================#
myserver = mysql.connector.connect(host="127.0.0.1", user="root", passwd="DbMs!ytye7")
mycursor = myserver.cursor()
mycursor.execute("USE Final")
mycursor.execute("SET GLOBAL log_bin_trust_function_creators = 1") #prevent error

for q in [h_shift_query, v_shift_query]:
    st = time.time()
    for i in range(0, 1000):
        execute1(mycursor, q, (random.randint(-99, 99), "001"))
    et = time.time()
    print(f"{q} executime: {et-st}")

for q in [corp_query]:
    st = time.time()
    for i in range(0, 1000):
        execute1(mycursor, q, (random.randint(0, 50), random.randint(0, 50), random.randint(1, 49), random.randint(1, 49), "001"))
    et = time.time()
    print(f"{q} executime: {et-st}")

for q in [h_flip_query, v_flip_query]:
    st = time.time()
    for i in range(0, 1000):
        execute1(mycursor, q, ("001", ))
    et = time.time()
    print(f"{q} executime: {et-st}")