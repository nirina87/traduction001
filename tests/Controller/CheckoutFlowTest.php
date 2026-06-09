<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class CheckoutFlowTest extends WebTestCase
{
    public function testPanierPageIsAccessible(): void
    {
        $client = static::createClient();

        $client->request('GET', '/panier');

        $this->assertResponseIsSuccessful();
    }

    public function testInscriptionPageIsAccessible(): void
    {
        $client = static::createClient();

        $client->request('GET', '/inscription');

        $this->assertResponseIsSuccessful();
    }
}
