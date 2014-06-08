#include <QGuiApplication>
#include <QtQml>
#include <QQuickView>
#include <QString>
#include <QStringListModel>

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    
    QDir entityDir("entities/");
    QStringList filters;
    filters << "*.qml";
    QStringList entities;
    foreach(QString entity, entityDir.entryList(filters)) {
        entities << ("entities/" + entity);
    }

    QStringListModel *entityModel = new QStringListModel(entities);

    context->setContextProperty("entityModel", entityModel);

    engine.load(QUrl::fromLocalFile("main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    window->show();

    return app.exec();
}   

