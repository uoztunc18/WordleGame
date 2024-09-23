#ifndef WORDLEGAME_h
#define WORDLEGAME_h

#include <QObject>
#include <QVariant>
#include <vector>
#include <string>
class WordleGame : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString targetWord READ targetWord WRITE setTargetWord NOTIFY targetWordChanged FINAL)
    Q_PROPERTY(int guessCount READ guessCount WRITE setGuessCount NOTIFY guessCountChanged FINAL)
    Q_PROPERTY(bool isGameOver READ isGameOver WRITE setIsGameOver NOTIFY isGameOverChanged FINAL)
    Q_PROPERTY(bool won READ won WRITE setWon NOTIFY wonChanged FINAL)

    Q_PROPERTY(QVariantList greenLetters READ greenLetters WRITE setGreenLetters NOTIFY greenLettersChanged FINAL)
    Q_PROPERTY(QVariantList yellowLetters READ yellowLetters WRITE setYellowLetters NOTIFY yellowLettersChanged FINAL)
    Q_PROPERTY(QVariantList checkedLetters READ checkedLetters WRITE setCheckedLetters NOTIFY checkedLettersChanged FINAL)
public:

    QVector<QString> dictionary;
    explicit WordleGame(QObject *parent = nullptr);

    QString targetWord();
    int guessCount();
    bool isGameOver();
    bool won();
    QVariantList greenLetters();
    QVariantList yellowLetters();
    QVariantList checkedLetters();

    Q_INVOKABLE void resetGame();

signals:
    void targetWordChanged();
    void guessCountChanged();
    void isGameOverChanged();
    void wonChanged();
    void greenLettersChanged();
    void yellowLettersChanged();
    void checkedLettersChanged();

public slots:
    void setTargetWord(QString);
    void setGuessCount(int);
    void setIsGameOver(bool);
    void setWon(bool);
    void setGreenLetters(QVariantList);
    void setYellowLetters(QVariantList);
    void setCheckedLetters(QVariantList);

    void loadDictionary();
    QString getRandomWord();
    bool isGuessValid(QString);
    QString isGuessCorrect(QString);

private:
    QString m_targetWord;
    int m_guessCount;
    bool m_isGameOver;
    bool m_won;
    std::vector<char> m_greenLetters;
    std::vector<char> m_yellowLetters;
    std::vector<char> m_checkedLetters;
};

#endif // WORDLEGAME_h
