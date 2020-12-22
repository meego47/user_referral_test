<?php


namespace App\Services;


use App\Models\User;

class UserBalanceService
{
    public function updateReferrerBalance(User $user, $sum)
    {
        if ($user->referrer) {
            $balance = $user->referrer->balance;
            $currentAmount = $balance->amount;
            $percent = config('user_balance.percent');
            $balance->amount = $currentAmount + ($sum * $percent / 100);
            $balance->save();
        }
    }
}
