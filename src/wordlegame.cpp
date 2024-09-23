#include "wordlegame.h"
#include <QDebug>
#include <QObject>
#include <QString>
#include <QVector>
#include <QFile>
#include <QTextStream>
#include <iostream>

#define WORD_SIZE 5
#define MAX_TURNS 6

WordleGame::WordleGame(QObject *parent) : QObject{parent} ,
    m_targetWord(""),
    m_guessCount(0),
    m_isGameOver(false),
    m_won(false)
{
    loadDictionary();
    m_targetWord = getRandomWord();
}

QString WordleGame::targetWord()
{
    return m_targetWord;
}

int WordleGame::guessCount()
{
    return m_guessCount;
}

bool WordleGame::isGameOver()
{
    return m_isGameOver;
}

bool WordleGame::won()
{
    return m_won;
}

QVariantList WordleGame::greenLetters()
{
    QVariantList list;
    for (char c : m_greenLetters) {
        list.append(QString(c));  // Convert char to QString
    }
    return list;
}

QVariantList WordleGame::yellowLetters()
{
    QVariantList list;
    for (char c : m_yellowLetters) {
        list.append(QString(c));  // Convert char to QString
    }
    return list;
}

QVariantList WordleGame::checkedLetters()
{
    QVariantList list;
    for (char c : m_checkedLetters) {
        list.append(QString(c));  // Convert char to QString
    }
    return list;
}

void WordleGame::setTargetWord(QString m_targetWord)
{
    this->m_targetWord = m_targetWord;
    emit targetWordChanged();
}

void WordleGame::setGuessCount(int m_guessCount)
{
    this->m_guessCount = m_guessCount;
    emit guessCountChanged();
}

void WordleGame::setIsGameOver(bool m_isGameOver)
{
    this->m_isGameOver = m_isGameOver;
    emit isGameOverChanged();
}

void WordleGame::setWon(bool m_won)
{
    this->m_won = m_won;
    emit wonChanged();
}

void WordleGame::setGreenLetters(QVariantList)
{
    this->m_greenLetters = m_greenLetters;
    emit greenLettersChanged();
}

void WordleGame::setYellowLetters(QVariantList)
{
    this->m_yellowLetters = m_yellowLetters;
    emit yellowLettersChanged();
}

void WordleGame::setCheckedLetters(QVariantList)
{
    this->m_checkedLetters = m_checkedLetters;
    emit checkedLettersChanged();
}

void WordleGame::loadDictionary() {
    QVector<QString> dictionary;
    QString word;
    QString filePath = ":/res/allowed_guesses.txt";
    QFile file(filePath);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream line(&file);

        while(!line.atEnd()) {
            word = line.readLine();
            dictionary.push_back(word);
        }

        std::cout << "DICTIONARY LOADED SUCCESSFULLY!" << std::endl;

    } else {
        std::cout << "FAILED TO LOAD DICTIONARY!" << std::endl;
    }

    file.close();
    this->dictionary = dictionary;
}

QString WordleGame::getRandomWord() {
    QString word;

    srand(time(0));
    word = dictionary.at(rand() % dictionary.size());

    qDebug() << "Picking a word... ->" << word;
    return word;
}

bool WordleGame::isGuessValid(QString guess) {
    if (dictionary.contains(guess.toLower())) {
        m_guessCount++;
        emit guessCountChanged();
        if (m_guessCount == 6) {
            m_isGameOver = true;
            emit isGameOverChanged();
        }
        return true;
    } else {
        qDebug() << "Guessed word is not found in dictionary!";
        return false;
    }
}

QString WordleGame::isGuessCorrect(QString guess) {
    QString colors = "bbbbb";
    QChar currentChar;

    int gCount = 0;

    // ALGORITHM
    for (int i = 0; i < WORD_SIZE; i++) {
        currentChar = m_targetWord[i].toUpper();

        if (std::find(m_checkedLetters.begin(), m_checkedLetters.end(), guess[i]) == m_checkedLetters.end()) {
            m_checkedLetters.push_back(guess[i].toLatin1());
            emit checkedLettersChanged();
        }

        if (currentChar == guess[i]) {
            colors[i] = 'g';
            if (std::find(m_greenLetters.begin(), m_greenLetters.end(), currentChar) == m_greenLetters.end()) {
                m_greenLetters.push_back(currentChar.toLatin1());
                emit greenLettersChanged();
            }
            gCount++;
            continue;
        }

        for (int j = 0; j < WORD_SIZE; j++) {
            if (currentChar == guess[j] && colors[j] == 'b') {
                colors[j] = 'y';
                if (std::find(m_yellowLetters.begin(), m_yellowLetters.end(), currentChar) == m_yellowLetters.end()) {
                    m_yellowLetters.push_back(currentChar.toLatin1());
                    emit yellowLettersChanged();
                }
                break;
            }
        }
    }

    // WIN CHECK
    if (gCount == WORD_SIZE) {
        qDebug() << "WINNNN";
        m_isGameOver = true;
        emit isGameOverChanged();

        m_won = true;
        emit wonChanged();
    }

    // qDebug() << m_greenLetters;
    // qDebug() << m_yellowLetters;
    // qDebug() << m_checkedLetters;

    return colors;
}

void WordleGame::resetGame() {
    qDebug() << "hLELOO";
    m_isGameOver = false;
    emit isGameOverChanged();
    m_won = false;
    emit wonChanged();
    m_guessCount = 0;
    emit guessCountChanged();
    m_targetWord = "";
    emit targetWordChanged();
    m_greenLetters.clear();
    emit greenLettersChanged();
    m_yellowLetters.clear();
    emit yellowLettersChanged();
    m_checkedLetters.clear();
    emit checkedLettersChanged();
}
