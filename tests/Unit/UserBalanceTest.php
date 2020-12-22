<?php

namespace Tests\Unit;

use App\Models\User;
use App\Services\UserBalanceService;
use Tests\TestCase;

class UserBalanceTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        \Config::set('user_balance.percent', 10);
    }

    public function test_success_if_balance_changed_from_default()
    {
        $referrer = User::factory()->create();
        $referral = User::factory()->create([
            'referrer_id' => $referrer->id
        ]);
        app(UserBalanceService::class)->updateReferrerBalance($referral, 100);
        self::assertEquals(10, $referrer->balance->amount);
    }

    public function test_success_if_balance_changed()
    {
        $referrer = User::factory()->create();
        $referral = User::factory()->create([
            'referrer_id' => $referrer->id
        ]);
        $referrer->balance->amount = 10;
        $referrer->balance->save();
        app(UserBalanceService::class)->updateReferrerBalance($referral, 100);
        $referrer->load('balance');
        self::assertEquals(20, $referrer->balance->amount);
    }
}
