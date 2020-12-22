<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function balance(): HasOne
    {
        return $this->hasOne(UserBalance::class)->withDefault([
            'amount' => 0
        ]);
    }

    public function referrals(): HasMany
    {
        return $this->hasMany(__CLASS__, 'referrer_id');
    }

    public function referrer(): BelongsTo
    {
        return $this->belongsTo(__CLASS__, 'referrer_id');
    }

    public function getReferralLinkAttribute()
    {
        return route('register', ['referrer' => $this->email]);
    }
}
