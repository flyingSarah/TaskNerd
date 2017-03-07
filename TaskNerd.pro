#-------------------------------------------------
#
# Project created by QtCreator 2016-06-05T12:21:27
#
#-------------------------------------------------

QT       += core gui quick qml sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = TaskNerd
TEMPLATE = app


SOURCES += main.cpp\
    Controller/TaskNerd.cpp \
    Model/TaskSqlModel.cpp \
    Model/DBData.cpp

HEADERS  += \
    Controller/TaskNerd.h \
    Model/TaskSqlModel.h \
    Model/DBData.h

OTHER_FILES += \
    Resources/QML/TaskNerd.qml \
    Resources/QML/TabRadioButton.qml \
    Resources/QML/RadioGroup.qml \
    Resources/QML/TabBar.qml \
    Resources/QML/TaskRow.qml \
    Resources/QML/TaskListView.qml \
    Resources/QML/Constants.js \
    Resources/QML/ToolBarButton.qml \
    Resources/QML/TaskCheckBox.qml \
    Resources/QML/TaskLabel.qml \
    Resources/QML/ToolBarMenu.qml \
    Resources/QML/TaskToolBar.qml
