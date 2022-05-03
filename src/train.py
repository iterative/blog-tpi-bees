"""train.py
Usage:
  train.py [options]

Options:
  -o=<file>, --output=<file>  : Output JSON metrics filename
      [default: metrics.json].
  -s=<num>, --seed=<num>      : Random seed [default: 42:int].
"""
import json
import logging
from pathlib import Path

import pandas as pd
import tensorflow as tf
from argopt import argopt
from sklearn.model_selection import train_test_split
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tqdm.keras import TqdmCallback

logging.basicConfig(level=logging.INFO)
IMAGE_WIDTH = 100
IMAGE_HEIGHT = 100
IMAGE_CHANNELS = 3
IMAGES_PATH = "data/bee_imgs/bee_imgs/"
BEE_DATA_CSV_PATH = "data/bee_data.csv"
BATCH_SIZE = 32
args = argopt(__doc__).parse_args()
RANDOM_STATE = args.seed

bee_data = pd.read_csv(BEE_DATA_CSV_PATH)
bee_labels = bee_data[["file", "subspecies"]]

OUTPUT_SIZE = bee_labels["subspecies"].nunique()
train_df, test_df = train_test_split(bee_labels, test_size=0.2, random_state=RANDOM_STATE)

image_generator = ImageDataGenerator(
    rescale=1.0 / 255,
    featurewise_center=False,
    samplewise_center=False,
    featurewise_std_normalization=False,
    samplewise_std_normalization=False,
    zca_whitening=False,
    rotation_range=180,
    zoom_range=0.1,
    width_shift_range=0.1,
    height_shift_range=0.1,
    horizontal_flip=True,
    vertical_flip=True,
    validation_split=0.2,
)

train_generator = image_generator.flow_from_dataframe(
    dataframe=train_df,
    directory=IMAGES_PATH,
    x_col="file",
    y_col="subspecies",
    target_size=(100, 100),
    color_mode="rgb",
    batch_size=BATCH_SIZE,
    seed=RANDOM_STATE,
    shuffle=True,
    class_mode="categorical",
    subset="training",
)
val_generator = image_generator.flow_from_dataframe(
    dataframe=train_df,
    directory=IMAGES_PATH,
    x_col="file",
    y_col="subspecies",
    target_size=(100, 100),
    color_mode="rgb",
    batch_size=BATCH_SIZE,
    seed=RANDOM_STATE,
    shuffle=True,
    class_mode="categorical",
    subset="validation",
)

test_generator = image_generator.flow_from_dataframe(
    dataframe=test_df,
    directory=IMAGES_PATH,
    x_col="file",
    y_col="subspecies",
    target_size=(100, 100),
    color_mode="rgb",
    class_mode="categorical",
)
print("Num GPUs Available: ", len(tf.config.list_physical_devices("GPU")))

model = keras.Sequential()
model.add(
    layers.Conv2D(
        16,
        kernel_size=3,
        input_shape=(IMAGE_WIDTH, IMAGE_HEIGHT, IMAGE_CHANNELS),
        activation="relu",
        padding="same",
    )
)
model.add(layers.MaxPool2D(2))
model.add(layers.Dropout(0.4))
model.add(layers.Conv2D(16, kernel_size=3, activation="relu", padding="same"))
model.add(layers.Dropout(0.4))
model.add(layers.Flatten())
model.add(layers.Dense(OUTPUT_SIZE, activation="softmax"))
model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])

model.fit(
    train_generator,
    steps_per_epoch=train_generator.samples // BATCH_SIZE,
    validation_data=val_generator,
    validation_steps=val_generator.samples // BATCH_SIZE,
    epochs=15,
    verbose=0,
    callbacks=[TqdmCallback()],
)

scores = model.evaluate(test_generator)

Path(args.output).parent.mkdir(parents=True, exist_ok=True)
with Path(args.output).open("w") as outfile:
    json.dump({"Accuracy": str(scores[1])}, outfile)
