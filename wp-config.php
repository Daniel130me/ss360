<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'gxzpywmy_WPJBL');

/** Database username */
define('DB_USER', 'gxzpywmy_WPJBL');

/** Database password */
define('DB_PASSWORD', '9Sdj9{VE$xf}kx*Y-');

/** Database hostname */
define('DB_HOST', 'localhost');

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY', '9492360a754cc7d77b55e0defa462c845d0f0c4ba94605feb98bd6586a0c7169');
define('SECURE_AUTH_KEY', 'd3ed68eb99fc60f754178c129d62d3049686236e706dbf4d62d43017358153b4');
define('LOGGED_IN_KEY', '8ad563ffe7b7c7dbac7476b7cb1bb944a38d861dc0df5d85e0c8406424adfc7e');
define('NONCE_KEY', 'dba9d81c072d8f643f67fbca07d2230a342471df087c015b0223aba08e6d9156');
define('AUTH_SALT', 'ca74e0269931b8337f74efa9fe7686daf6871a3024b510837fb8ac1795cc808e');
define('SECURE_AUTH_SALT', 'f67d2e46414e255ca4aa41e142e059e927b8c0814540500aa28b2817b405ee0e');
define('LOGGED_IN_SALT', 'bfeb7f6c7163cfb8e6876b273c28e48607c01c1c48df47a0447747421e4ad018');
define('NONCE_SALT', '1aa91e564d10407b50510e85ac1e6c69f1e9f3228686374c1dd4f4dd5c7506c3');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'G1i_';
define('WP_CRON_LOCK_TIMEOUT', 120);
define('AUTOSAVE_INTERVAL', 300);
define('WP_POST_REVISIONS', 20);
define('EMPTY_TRASH_DAYS', 7);
define('WP_AUTO_UPDATE_CORE', true);

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
