import pandas as pd
import mysql.connector
import sys
import numpy as np
from PIL import Image, ImageOps
from stored_fn import h_shift_fn, v_shift_fn, corp_fn, h_flip_fn, v_flip_fn

#==========================================#
#=============function & query=============#
#==========================================#
#python
def check(c, q, p):
    q_ = "SELECT width, height FROM picture WHERE idx=%s"
    c.execute(q_, (p[-1],))
    record = c.fetchone()
    w = record[0]
    h = record[1]
    
    c.execute(q, p)
    record = c.fetchone()
    fn_name = q.split(" ")[1].split("(")[0]
    if len(record) > 2:
        pic = np.frombuffer(record[1], dtype=np.uint8).reshape((w, h))
    else:
        pic = np.frombuffer(record[0], dtype=np.uint8).reshape((w, h))
        img = Image.fromarray(pic)
        img.save(f"{fn_name}.png")
    #print(f"pic received by query {q} with {p} is:")
    #print(pic)

#mySQL
insert_blob_query = " INSERT INTO picture (idx, pic, width, height, label) VALUES (%s,%s,%s,%s,%s)"
get_blob_query = "SELECT * FROM picture WHERE idx=%s"

h_shift_query = "SELECT h_shift(pic, width, height, %s) FROM picture WHERE idx=%s"
v_shift_query = "SELECT v_shift(pic, width, height, %s) FROM picture WHERE idx=%s"
corp_query = "SELECT corp(pic, width, height, %s, %s, %s, %s) FROM picture WHERE idx=%s"
h_flip_query = "SELECT h_flip(pic, width, height) FROM picture WHERE idx=%s"
v_flip_query = "SELECT v_flip(pic, width, height) FROM picture WHERE idx=%s"

#==============================#
#=============main=============#
#==============================#
#connect & create DB
myserver = mysql.connector.connect(host="127.0.0.1", user="", passwd="") #fill in yourself
mycursor = myserver.cursor()
mycursor.execute("DROP DATABASE IF EXISTS Final")
mycursor.execute("CREATE DATABASE Final")
#create table
mycursor.execute("USE Final")
mycursor.execute("SET GLOBAL log_bin_trust_function_creators = 1")
mycursor.execute("DROP TABLE IF EXISTS picture")
statement = "CREATE TABLE picture ( idx VARCHAR(5) NOT NULL PRIMARY KEY, pic BLOB NOT NULL, width INT NOT NULL, height INT NOT NULL, label VARCHAR(5) NOT NULL)"
mycursor.execute(statement)
#create function
mycursor.execute("DROP FUNCTION IF EXISTS h_shift")
mycursor.execute(h_shift_fn)
mycursor.execute("DROP FUNCTION IF EXISTS v_shift")
mycursor.execute(v_shift_fn)
mycursor.execute("DROP FUNCTION IF EXISTS corp")
mycursor.execute(corp_fn)
mycursor.execute("DROP FUNCTION IF EXISTS h_flip")
mycursor.execute(h_flip_fn)
mycursor.execute("DROP FUNCTION IF EXISTS v_flip")
mycursor.execute(v_flip_fn)
#insert picture
picture = np.array(ImageOps.grayscale(Image.open("./DBMS_final2.png")))
#print("picture:")
#print(picture)
picture = picture.tobytes()
#picture = np.array([[0, 1, 2], [3, 4, 5], [6, 7, 8]], dtype=np.uint8).tobytes() #picture prototype
result = mycursor.execute(insert_blob_query, ("001", picture, 100, 100, "1"))
myserver.commit()


#get picture
check(mycursor, get_blob_query, ("001",))
#test functions
#check(mycursor, h_shift_query, (2, "001"))
check(mycursor, h_shift_query, (-30, "001"))
#check(mycursor, v_shift_query, (4, "001"))
check(mycursor, v_shift_query, (-50, "001"))
check(mycursor, corp_query, (20, 10, 70, 60, "001"))
check(mycursor, h_flip_query, ("001",))
check(mycursor, v_flip_query, ("001",))
    
