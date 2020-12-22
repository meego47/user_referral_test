<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUserBalanceTable extends Migration
{
    public function up()
    {
        Schema::create('user_balance', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id')->unique();
            $table->decimal('amount', 15, 5);
            $table->foreign('user_id')
                ->on('users')
                ->references('id')
                ->onDelete('RESTRICT');
        });
    }

    public function down()
    {
        Schema::dropIfExists('user_balance');
    }
}
