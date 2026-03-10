// Copyright (c) 2009-2025 Satoshi Nakamoto
// Copyright (c) 2009-2024 The Bitcoin Core developers
// Copyright (c) 2025 The PWDH developers
// Forked from Bitcoin Core version 0.27.0
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.


#include <pow.h>

#include <arith_uint256.h>
#include <chain.h>
#include <primitives/block.h>
#include <uint256.h>

unsigned int GetNextWorkRequired(const CBlockIndex* pindexLast, const CBlockHeader *pblock, const Consensus::Params& params)
{
    assert(pindexLast != nullptr);
    unsigned int nProofOfWorkLimit = UintToArith256(params.powLimit).GetCompact();

    if (params.fPowNoRetargeting) return pindexLast->nBits;

    const int64_t target_spacing = params.nPowTargetSpacing;
    const int64_t window_n = params.DifficultyAdjustmentInterval();
    if (window_n <= 0 || target_spacing <= 0) return pindexLast->nBits;

    if (params.fPowAllowMinDifficultyBlocks) {
        if (pblock->GetBlockTime() > pindexLast->GetBlockTime() + target_spacing * 2) {
            return nProofOfWorkLimit;
        }
    }

    const arith_uint256 pow_limit = UintToArith256(params.powLimit);
    arith_uint256 prev_target;
    prev_target.SetCompact(pindexLast->nBits);

    int64_t actual_timespan = 0;
    int64_t counted = 0;
    const CBlockIndex* pindex = pindexLast;
    while (pindex && pindex->pprev && counted < window_n) {
        int64_t solvetime = pindex->GetBlockTime() - pindex->pprev->GetBlockTime();
        if (solvetime < 1) solvetime = 1;
        const int64_t max_solvetime = 6 * target_spacing;
        if (solvetime > max_solvetime) solvetime = max_solvetime;
        actual_timespan += solvetime;
        pindex = pindex->pprev;
        counted++;
    }

    if (counted == 0) return pindexLast->nBits;
    const int64_t target_timespan = counted * target_spacing;

    int64_t min_timespan = target_timespan / 4;
    int64_t max_timespan = target_timespan * 4;
    if (actual_timespan < min_timespan) actual_timespan = min_timespan;
    if (actual_timespan > max_timespan) actual_timespan = max_timespan;

    arith_uint256 new_target = prev_target;
    new_target *= actual_timespan;
    new_target /= target_timespan;

    arith_uint256 min_target = prev_target;
    min_target /= 4;
    arith_uint256 max_target = prev_target;
    max_target *= 4;
    if (new_target < min_target) new_target = min_target;
    if (new_target > max_target) new_target = max_target;
    if (new_target > pow_limit) new_target = pow_limit;

    return new_target.GetCompact();
}

unsigned int CalculateNextWorkRequired(const CBlockIndex* pindexLast, int64_t nFirstBlockTime, const Consensus::Params& params)
{
    if (params.fPowNoRetargeting)
        return pindexLast->nBits;

    // Limit adjustment step
    int64_t nActualTimespan = pindexLast->GetBlockTime() - nFirstBlockTime;
    if (nActualTimespan < params.nPowTargetTimespan/4)
        nActualTimespan = params.nPowTargetTimespan/4;
    if (nActualTimespan > params.nPowTargetTimespan*4)
        nActualTimespan = params.nPowTargetTimespan*4;

    // Retarget
    const arith_uint256 bnPowLimit = UintToArith256(params.powLimit);
    arith_uint256 bnNew;
    bnNew.SetCompact(pindexLast->nBits);
    bnNew *= nActualTimespan;
    bnNew /= params.nPowTargetTimespan;

    if (bnNew > bnPowLimit)
        bnNew = bnPowLimit;

    return bnNew.GetCompact();
}

// Check that on difficulty adjustments, the new difficulty does not increase
// or decrease beyond the permitted limits.
bool PermittedDifficultyTransition(const Consensus::Params& params, int64_t height, uint32_t old_nbits, uint32_t new_nbits)
{
    if (params.fPowAllowMinDifficultyBlocks) return true;

    const arith_uint256 pow_limit = UintToArith256(params.powLimit);
    arith_uint256 old_target;
    old_target.SetCompact(old_nbits);
    arith_uint256 new_target;
    new_target.SetCompact(new_nbits);

    arith_uint256 min_target = old_target;
    min_target /= 4;
    arith_uint256 max_target = old_target;
    max_target *= 4;
    if (new_target < min_target) return false;
    if (new_target > max_target) return false;
    if (new_target > pow_limit) return false;
    return true;
}

bool CheckProofOfWork(uint256 hash, unsigned int nBits, const Consensus::Params& params)
{
    bool fNegative;
    bool fOverflow;
    arith_uint256 bnTarget;

    bnTarget.SetCompact(nBits, &fNegative, &fOverflow);

    // Check range
    if (fNegative || bnTarget == 0 || fOverflow || bnTarget > UintToArith256(params.powLimit))
        return false;

    // Check proof of work matches claimed amount
    if (UintToArith256(hash) > bnTarget)
        return false;

    return true;
}
