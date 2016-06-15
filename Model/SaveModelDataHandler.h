#ifndef SAVEMODELDATAHANDLER_H
#define SAVEMODELDATAHANDLER_H

//#include <QObject>
#include <QVariantMap>
#include <QDebug>

#include "Model/ListModel.h"

class SaveModelDataHandler
{

public:
    SaveModelDataHandler(Models::ListModel *model);

private:
    QVariantMap modelMap;

    QVariantMap saveModelData(Models::ListModel *model);
};

#endif // SAVEMODELDATAHANDLER_H
