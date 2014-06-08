#include <QGuiApplication>
#include <QtQml>
#include <QQuickView>
#include <QString>
#include <QStringListModel>
#include <QQuickItem>
#include <QDebug>

#include "qmlwriter.h"

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    
    QDir entityDir("mygame/");
    QStringList filters;
    filters << "*.qml";
    QStringList entities;
    foreach(QString entity, entityDir.entryList(filters)) {
        if(!entity.contains("game.qml")) {
            entities << ("mygame/" + entity);
        }
    }

    QStringListModel *entityModel = new QStringListModel(entities);
    QmlWriter *qmlWriter = new QmlWriter();

    context->setContextProperty("qmlWriter", qmlWriter);
    context->setContextProperty("entityModel", entityModel);

    engine.load(QUrl::fromLocalFile("main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    window->show();

    return app.exec();
}   

