// Copyright (c) 2009-2025 Satoshi Nakamoto
// Copyright (c) 2009-2024 The Bitcoin Core developers
// Copyright (c) 2025 The PWDH developers
// Forked from Bitcoin Core version 0.27.0
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.


#ifndef PWDH_QT_PWDHADDRESSVALIDATOR_H
#define PWDH_QT_PWDHADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class PWDHAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit PWDHAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

/** PWDH address widget validator, checks for a valid pwdh address.
 */
class PWDHAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit PWDHAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

#endif // PWDH_QT_PWDHADDRESSVALIDATOR_H
