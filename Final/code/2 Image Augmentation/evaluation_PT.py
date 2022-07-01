import PIL.Image as Image
import torch
import torchvision
import torchvision.transforms as tf
import numpy as np
import time
import random

img = Image.open("./DBMS_final_g.png")
img = np.asarray(img)
img = torch.from_numpy(img).unsqueeze(0)

st = time.time()
for i in range(0, 1000):
    angle, scale, shear = 0, 1, 0
    translate = (random.randint(0, 99), 0)
    image = tf.functional.affine(img, angle, translate, scale, shear)
et = time.time()
print(f"h_s time:{et-st}")

st = time.time()
for i in range(0, 1000):
    angle, scale, shear = 0, 1, 0
    translate = (0, random.randint(0, 99))
    image = tf.functional.affine(img, angle, translate, scale, shear)
et = time.time()
print(f"v_s time:{et-st}")

r = tf.RandomHorizontalFlip(1.0)
st = time.time()
for i in range(0, 1000):
    image = r(img)
et = time.time()
print(f"h_f time:{et-st}")

v = tf.RandomVerticalFlip(1.0)
st = time.time()
for i in range(0, 1000):
    image = v(img)
et = time.time()
print(f"v_f time:{et-st}")

v = tf.RandomResizedCrop(100, (0.5, 1.0), )
st = time.time()
for i in range(0, 1000):
    image = v(img)
et = time.time()
print(f"c time:{et-st}")
