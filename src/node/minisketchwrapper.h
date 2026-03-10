// Copyright (c) 2009-2025 Satoshi Nakamoto
// Copyright (c) 2009-2024 The Bitcoin Core developers
// Copyright (c) 2025 The PWDH developers
// Forked from Bitcoin Core version 0.27.0
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.


#ifndef PWDH_NODE_MINISKETCHWRAPPER_H
#define PWDH_NODE_MINISKETCHWRAPPER_H

#include <minisketch.h>

#include <cstddef>
#include <cstdint>

namespace node {
/** Wrapper around Minisketch::Minisketch(32, implementation, capacity). */
Minisketch MakeMinisketch32(size_t capacity);
/** Wrapper around Minisketch::CreateFP. */
Minisketch MakeMinisketch32FP(size_t max_elements, uint32_t fpbits);
} // namespace node

#endif // PWDH_NODE_MINISKETCHWRAPPER_H
