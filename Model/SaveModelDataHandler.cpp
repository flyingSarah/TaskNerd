#include "SaveModelDataHandler.h"

SaveModelDataHandler::SaveModelDataHandler(Models::ListModel *model)
{
    //TODO: do this next: figure out if I should make the model reference a const & ??
    modelMap = saveModelData(model);
    qDebug() << modelMap;
}

QVariantMap SaveModelDataHandler::saveModelData(Models::ListModel *model)
{
    QVariantMap listMap;

    for(int i = 0; i < model->rowCount(); ++i)
    {
        QHash<int, QByteArray> roleNames = model->roleNames();

        int roleMin = Qt::UserRole+1;
        int roleMax = roleMin + model->roleNames().count();

        QVariantMap taskMap;

        for(int j = roleMin; j < roleMax; ++j)
        {
            taskMap.insert(roleNames[j], model->data(model->index(i), j));
        }

        listMap.insert(QString("task_%1").arg(i), taskMap);
        taskMap.clear();
    }

    return listMap;
}
