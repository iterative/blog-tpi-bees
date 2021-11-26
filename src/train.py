import pandas as pd
import numpy as np
import os as os
import skimage
import skimage.io
import skimage.transform
from sklearn.model_selection import train_test_split
from keras.models import Sequential
from keras.layers import Dense, Conv2D, Flatten, MaxPool2D, Dropout
from keras.preprocessing.image import ImageDataGenerator
from sklearn import metrics


IMAGE_WIDTH = 100
IMAGE_HEIGHT = 100
IMAGE_CHANNELS = 3
IMAGES_PATH = "data/bee_imgs/bee_imgs/"
BEE_DATA_CSV_PATH = "data/bee_data.csv"
RANDOM_STATE = 42

bee_data = pd.read_csv(BEE_DATA_CSV_PATH)

def read_image_sizes(file_name):
    image = skimage.io.imread(IMAGES_PATH + file_name)
    return list(image.shape)

m = np.stack(bee_data['file'].apply(read_image_sizes))
df = pd.DataFrame(m,columns=['w','h','c'])

bee_data = pd.concat([bee_data,df],axis=1, sort=False)
bee_data = bee_data.replace({'location':'Athens, Georgia, USA'}, 'Athens, GA, USA')

train_df, test_df = train_test_split(bee_data, test_size=0.2, random_state=RANDOM_STATE)

train_df, val_df = train_test_split(train_df, test_size=0.2, random_state=RANDOM_STATE)


#A function for reading images from the image files, scale all images to 100 x 100 x 3 (channels).

def read_image(file_name):
    image = skimage.io.imread(IMAGES_PATH + file_name)
    image = skimage.transform.resize(image, (IMAGE_WIDTH, IMAGE_HEIGHT), mode='reflect')
    return image[:,:,:IMAGE_CHANNELS]


#A function to create the dummy variables corresponding to the categorical target variable.

def categories_encoder(dataset, var='subspecies'):
    X = np.stack(dataset['file'].apply(read_image))
    y = pd.get_dummies(dataset[var], drop_first=False)
    return X, y

X_train, y_train = categories_encoder(train_df)
X_val, y_val = categories_encoder(val_df)
X_test, y_test = categories_encoder(test_df)
OUTPUT_SIZE = y_train.columns.size


model=Sequential()
model.add(Conv2D(16, kernel_size=3, input_shape=(IMAGE_WIDTH, IMAGE_HEIGHT,IMAGE_CHANNELS), activation='relu', padding='same'))
model.add(MaxPool2D(2))
model.add(Dropout(0.4))
model.add(Conv2D(16, kernel_size=3, activation='relu', padding='same'))
model.add(Dropout(0.4))
model.add(Flatten())
model.add(Dense(OUTPUT_SIZE, activation='softmax'))
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

    # ImageDataGenerator creates random variation of the training dataset, by applying various techniques, including: 
    # rotation (in a range of 0-180 degrees) of the original images; zoom (10%); shift in horizontal and in vertical direction (10%); 
    # horizontal and vertical flip
image_generator = ImageDataGenerator(
    featurewise_center=False,
    samplewise_center=False,
    featurewise_std_normalization=False,
    samplewise_std_normalization=False,
    zca_whitening=False,
    rotation_range=180,
    zoom_range = 0.1, 
    width_shift_range=0.1,
    height_shift_range=0.1, 
    horizontal_flip=True,
    vertical_flip=True)
image_generator.fit(X_train)

model.fit_generator(image_generator.flow(X_train, y_train, batch_size=32),
                        epochs=15,
                        validation_data=[X_val, y_val],
                        steps_per_epoch=len(X_train)/32)
    

def log_metrics(trained_model, X_test, y_test):
    predicted = trained_model.predict(X_test)
    test_predicted = np.argmax(predicted, axis=1)
    test_truth = np.argmax(y_test.values, axis=1)
# todo: write metrics to a json file instead
    print(metrics.classification_report(test_truth, test_predicted, target_names=y_test.columns)) 
    test_res = trained_model.evaluate(X_test, y_test.values, verbose=0)
    print('Loss function: %s, accuracy:' % test_res[0], test_res[1])


log_metrics(model, X_test, y_test)
