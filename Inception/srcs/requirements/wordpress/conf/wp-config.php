<?php

define( 'DB_NAME', getenv('MYSQL_DATABASE') );
define( 'DB_USER', getenv('MYSQL_ADMIN_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_ADMIN_PASSWORD') );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define( 'WP_CACHE' , true);

define('AUTH_KEY',         'nynZN@p%~s+VI2R}}wUJ[QIeCFk-DkNI)A:h=badn/,4xBpfAt,y(#,N}hnGAk [');
define('SECURE_AUTH_KEY',  '5}`z5X=]VN(~tp&pMG(~cwLoxIC`cnRqAP5Yf|f%^aN9-H+1O!|feL}slY#laZF9');
define('LOGGED_IN_KEY',    '_CI;<.-Yb#q6/C)w5BO*Qw!+rrp}umu+0bg|E,p<zdg T#E.|.<{|(BDczhL<#v(');
define('NONCE_KEY',        'M3eR`S~+F[Ie%NyZ$0x}(8:+FEp{cI?}J>J-j)cXU_Vno#,ylXd3|y`;#,fNlzX5');
define('AUTH_SALT',        'F)vM!awJo~0[A :hBe^Er1fv6uE0|*N*c+5>CYGRv` )E+@sk(&j?~@MX/d>!Tz~');
define('SECURE_AUTH_SALT', 'VK8-jb3.JA$|8]m&0TSoG#4nQ>+e1kB}A&ZYPzzJ.Ol#3  |tJlN.,IlL}.TAX5#');
define('LOGGED_IN_SALT',   'HcgLD)(7|e]E@1nh(|i~*dK+Pj*#T;rc+SR1*+{C%gQAD7is>xHT6*6O]b(J;G#m');
define('NONCE_SALT',       '=5RgOJnbZn:z7C&bv-x:O]$6cnkv.SRz!2Us F~Uvn:$PuKo8he`Wh,r!-p3x`h1');

// Essas chaves e "salts" são usados para melhorar a segurança das sessões e cookies gerados pelo WordPress, 
// dificultando que hackers descubram informações sensíveis ou acessem áreas administrativas sem permissão. 
// Cada chave é gerada aleatoriamente e deve ser única.

$table_prefix = 'wp_';
// O prefixo que será adicionado a todas as tabelas do banco de dados do WordPress. 
// Isso é útil quando se deseja instalar múltiplos WordPress no mesmo banco de dados (diferenciando-os pelo prefixo).

define( 'WP_DEBUG', false );
// Habilita o cache no WordPress. O cache pode melhorar significativamente o desempenho, armazenando páginas geradas em vez de recalculá-las a cada requisição.
// Quando definido como true, o WordPress exibe mensagens de erro e avisos que são úteis durante o desenvolvimento. 
// No entanto, em ambientes de produção, ele deve estar desativado (false) para evitar a exibição de mensagens de erro sensíveis.

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}
// Define o caminho absoluto para a pasta onde o WordPress está instalado. 
// O ABSPATH é usado internamente para garantir que o WordPress saiba onde estão seus arquivos.

require_once ABSPATH . 'wp-settings.php';
// Este comando carrega o arquivo wp-settings.php, que inicializa o WordPress, configurando suas funcionalidades e carregando plugins, temas, entre outros.
