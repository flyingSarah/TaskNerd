#include <QGuiApplication>

#include <qqmlengine.h>
#include <qqmlcontext.h>
#include <qqml.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>

#include "Controller/TaskNerd.h"

int main(int argc, char *argv[])
{
    QGuiApplication a(argc, argv);

    QQuickView *window = new QQuickView();
    new TaskNerd(window);

    return a.exec();
}
