#-------------------------------------------------
#
# Project created by QtCreator 2016-06-05T12:21:27
#
#-------------------------------------------------

QT       += core gui quick qml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = TaskNerd
TEMPLATE = app


SOURCES += main.cpp\
    Controller/TaskNerd.cpp \
    Model/ListModel.cpp \
    Model/TaskModel.cpp \
    Model/RepeatingTaskModel.cpp \
    Model/SaveModelDataHandler.cpp

HEADERS  += \
    Controller/TaskNerd.h \
    Model/ListItem.h \
    Model/ListModel.h \
    Model/TaskModel.h \
    Model/RepeatingTaskModel.h \
    Model/SaveModelDataHandler.h

OTHER_FILES += \
    Resources/QML/TaskNerd.qml \
    Resources/QML/TabRadioButton.qml \
    Resources/QML/RadioGroup.qml \
    Resources/QML/TabBar.qml \
    Resources/QML/TaskRow.qml \
    Resources/QML/TaskListView.qml
