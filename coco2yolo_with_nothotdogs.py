from pycocotools.coco import COCO
import numpy as np
import os
import shutil
import random
from shutil import copyfile

dataDir='.'
dataType='train2014'

annFile = '{}/annotations/instances_{}.json'.format(dataDir,dataType)
imgDir = '{}/{}'.format(dataDir,dataType)

coco=COCO(annFile)

food_categories = ['banana', 'apple', 'sandwich', 'orange', 'broccoli', 'carrot', 'pizza', 'donut', 'cake']

# Get 'hot dog' images
category = 'hot dog'
classId = 0
exportDir = 'output/' + category.replace(' ', '') + '/' + dataType
os.makedirs(exportDir, exist_ok=True)

catIds = coco.getCatIds(catNms=[category])
imgIds = coco.getImgIds(catIds=catIds)
imgs = coco.loadImgs(imgIds)

hot_dog_count = len(imgs)

# Create directories for images and labels
os.makedirs('output/images/train', exist_ok=True)
os.makedirs('output/images/val', exist_ok=True)
os.makedirs('output/images/test', exist_ok=True)
os.makedirs('output/labels/train', exist_ok=True)
os.makedirs('output/labels/val', exist_ok=True)
os.makedirs('output/labels/test', exist_ok=True)

# Function to process images
def process_images(imgs, classId, exportDir):
    data = []
    for img in imgs: 
        fileName = img["file_name"]
        imgPath = imgDir + '/' + fileName
        newPath = exportDir + '/' + fileName
        txtFile = exportDir + '/' + os.path.splitext(fileName)[0] + '.txt'
        copyfile(imgPath, newPath)
        dw = 1. / img['width']
        dh = 1. / img['height']
        annIds = coco.getAnnIds(imgIds=img['id'], catIds=catIds, iscrowd=None)
        anns = coco.loadAnns(annIds)
        with open(txtFile, 'w+') as file:
            for ann in anns:
                box = ann["bbox"]
                x = box[0] + box[2]/2
                y = box[1] + box[3]/2
                w = box[2]
                h = box[3]
                x = round(x * dw, 3)
                w = round(w * dw, 3)
                y = round(y * dh, 3)
                h = round(h * dh, 3)
                str = "{} {} {} {} {}\n".format(classId, x, y, w, h)
                file.write(str)
        data.append((newPath, txtFile))
    return data

data = process_images(imgs, classId, exportDir)

# Get equal number of images from other food categories
classId = 1
for category in food_categories:
    exportDir = 'output/' + category.replace(' ', '') + '/' + dataType
    os.makedirs(exportDir, exist_ok=True)
    catIds = coco.getCatIds(catNms=[category])
    imgIds = coco.getImgIds(catIds=catIds)
    imgs = coco.loadImgs(imgIds)
    if len(imgs) > hot_dog_count:
        imgs = imgs[:hot_dog_count]  # Limit to the same number as 'hot dog' images
    data += process_images(imgs, classId, exportDir)

# Shuffle data and split into train, val, and test
random.shuffle(data)
num_train = int(len(data) * 0.8)
num_val = int(len(data) * 0.15)
train_data = data[:num_train]
val_data = data[num_train:num_train+num_val]
test_data = data[num_train+num_val:]

# Function to move files
def move_files(data, img_dir, label_dir):
    for img_path, label_path in data:
        img_dest = os.path.join(img_dir, os.path.basename(img_path))
        label_dest = os.path.join(label_dir, os.path.basename(label_path))

        # Check if file already exists and rename if necessary
        if os.path.exists(img_dest):
            base, ext = os.path.splitext(img_dest)
            i = 1
            while os.path.exists(img_dest):
                img_dest = base + "_" + str(i) + ext
                i += 1

        if os.path.exists(label_dest):
            base, ext = os.path.splitext(label_dest)
            i = 1
            while os.path.exists(label_dest):
                label_dest = base + "_" + str(i) + ext
                i += 1

        shutil.move(img_path, img_dest)
        shutil.move(label_path, label_dest)

# Move files to respective directories
move_files(train_data, 'output/images/train', 'output/labels/train')
move_files(val_data, 'output/images/val', 'output/labels/val')
move_files(test_data, 'output/images/test', 'output/labels/test')