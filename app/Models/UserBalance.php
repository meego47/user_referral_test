<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserBalance extends Model
{
    protected $fillable = ['user_id', 'amount'];
    protected $table = 'user_balance';
    public $timestamps = false;
}
