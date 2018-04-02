#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "Controller/TaskNerd.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    new TaskNerd(&engine);

    if(engine.rootObjects().isEmpty())
    {
        return -1;
    }

    return app.exec();
}
