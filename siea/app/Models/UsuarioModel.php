<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de usuarios del sistema.
 *
 * Roles: admin, preceptora, coordinadora, vicerrectora.
 * Turnos: mañana, tarde, ambos.
 *
 * REGLA: la contraseña NUNCA se devuelve en las consultas normales.
 * Solo la pedimos explícitamente en el login con ->select('clave_hash').
 */
class UsuarioModel extends Model
{
    protected $table            = 'usuarios';
    protected $primaryKey       = 'id_usuario';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields = [
        'nombre',
        'usuario',
        'clave_hash',
        'rol',
        'turno',
        'activo',
    ];

    // Timestamps no están en la tabla usuarios, así que los desactivamos.
    protected $useTimestamps = false;

    /**
     * Reglas de validación comunes.
     * Se usan desde el controlador con ->validate().
     */
    protected $validationRules = [
        'nombre'     => 'required|min_length[3]|max_length[120]',
        'usuario'    => 'required|min_length[3]|max_length[60]|is_unique[usuarios.usuario,id_usuario,{id_usuario}]',
        'rol'        => 'required|in_list[admin,preceptora,coordinadora,vicerrectora]',
        'turno'      => 'required|in_list[mañana,tarde,ambos]',
        'activo'     => 'required|in_list[0,1]',
    ];

    protected $validationMessages = [
        'usuario' => [
            'is_unique' => 'Ese nombre de usuario ya existe.',
        ],
        'rol' => [
            'in_list' => 'Rol inválido.',
        ],
        'turno' => [
            'in_list' => 'Turno inválido.',
        ],
    ];

    /**
     * Busca un usuario por nombre de usuario, SOLO si está activo.
     * Incluye clave_hash para poder verificar la contraseña en el login.
     *
     * @return array|null
     */
    public function buscarActivoPorUsuario(string $usuario): ?array
    {
        return $this->select('id_usuario, nombre, usuario, clave_hash, rol, turno, activo')
                    ->where('usuario', $usuario)
                    ->where('activo', 1)
                    ->first();
    }

    /**
     * Lista todos los usuarios ordenados por rol y nombre.
     * No devuelve clave_hash.
     */
    public function listarTodos(): array
    {
        return $this->select('id_usuario, nombre, usuario, rol, turno, activo')
                    ->orderBy('rol', 'ASC')
                    ->orderBy('nombre', 'ASC')
                    ->findAll();
    }
}