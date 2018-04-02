#-------------------------------------------------
#
# Project created by QtCreator 2016-06-05T12:21:27
#
#-------------------------------------------------

QT       += core gui quick qml sql
CONFIG   += c++11

DEFINES += QT_DEPRECATED_WARNINGS

TARGET = TaskNerd
TEMPLATE = app


SOURCES += \
    main.cpp \
    Controller/TaskNerd.cpp \
    Model/TaskSqlModel.cpp \
    Model/DBData.cpp

HEADERS  += \
    Controller/TaskNerd.h \
    Model/TaskSqlModel.h \
    Model/DBData.h

RESOURCES += \
    qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
