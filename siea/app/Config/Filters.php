<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;
use CodeIgniter\Filters\CSRF;
use CodeIgniter\Filters\DebugToolbar;
use CodeIgniter\Filters\Honeypot;
use CodeIgniter\Filters\InvalidChars;
use CodeIgniter\Filters\SecureHeaders;
use App\Filters\AuthFilter;
use App\Filters\RoleFilter;
use App\Filters\TurnoFilter;

/**
 * Configuración de filtros — Etapa 2.
 *
 * Aliases registrados:
 *   - auth  → AuthFilter   (verifica sesión)
 *   - role  → RoleFilter   (verifica rol, ej: role:admin)
 *   - turno → TurnoFilter  (verifica turno de preceptora)
 *
 * Los filtros globales antes/después se mantienen mínimos para no
 * bloquear el login. auth/role/turno se aplican por grupo de rutas.
 */
class Filters extends BaseConfig
{
    public array $aliases = [
        'csrf'          => CSRF::class,
        'toolbar'       => DebugToolbar::class,
        'honeypot'      => Honeypot::class,
        'invalidchars'  => InvalidChars::class,
        'secureheaders' => SecureHeaders::class,
        // Filtros propios del S.I.E.A.:
        'auth'          => AuthFilter::class,
        'role'          => RoleFilter::class,
        'turno'         => TurnoFilter::class,
    ];

    public array $globals = [
        'before' => [
            'csrf',
            'invalidchars',
        ],
        'after' => [
            'secureheaders',
        ],
    ];

    public array $methods = [];

    public array $filters = [];
}