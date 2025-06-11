<?php

require 'vendor/autoload.php';

use Google\Auth\Credentials\ServiceAccountCredentials;
use GuzzleHttp\Client;

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, Access-Control-Allow-Origin");
header("Access-Control-Allow-Methods: POST, OPTIONS, GET, PUT, DELETE"); // Allow POST, OPTIONS, GET, PUT, DELETE methods


define("MB", 1048576);

function filterRequest($requestname)
{
    return  htmlspecialchars(strip_tags($_POST[$requestname]));
}

function getAllData($table, $where = null, $values = null, $json = true)
{
    global $con;
    $data = array();
    if ($where == null) {
        $stmt = $con->prepare("SELECT  * FROM $table  ");
    } else {
        $stmt = $con->prepare("SELECT  * FROM $table WHERE   $where ");
    }

    $stmt->execute($values);
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $count  = $stmt->rowCount();

    if ($json == true) {
        if ($count > 0) {
            echo json_encode(array("status" => "success", "data" => $data));
        }
     else {
        echo json_encode(array("status" => "failure"));
    }

    return $count;
    }

else {if ($count > 0) {
    return array("status" => "success", "data"=> $data);
} else {
    return  array("status" => "failure");
}}
    
}


function insertData($table, $data, $json = true)
{
    global $con;
    foreach ($data as $field => $v)
        $ins[] = ':' . $field;
    $ins = implode(',', $ins);
    $fields = implode(',', array_keys($data));
    $sql = "INSERT INTO $table ($fields) VALUES ($ins)";

    $stmt = $con->prepare($sql);
    foreach ($data as $f => $v) {
        $stmt->bindValue(':' . $f, $v);
    }
    $stmt->execute();
    $count = $stmt->rowCount();
    if ($json == true) {
        if ($count > 0) {
            echo json_encode(array("status" => "success"));
        } else {
            echo json_encode(array("status" => "failure"));
        }
    }
    return $count;
}


function updateData($table, $data, $where, $json = true)
{
    global $con;
    $cols = array();
    $vals = array();

    foreach ($data as $key => $val) {
        $vals[] = "$val";
        $cols[] = "`$key` =  ? ";
    }
    $sql = "UPDATE $table SET " . implode(', ', $cols) . " WHERE $where";

    $stmt = $con->prepare($sql);
    $stmt->execute($vals);
    $count = $stmt->rowCount();
    if ($json == true) {
        if ($count > 0) {
            echo json_encode(array("status" => "success"));
        } else {
            echo json_encode(array("status" => "failure"));
        }
    }
    return $count;
}

function deleteData($table, $where, $json = true)
{
    global $con;
    $stmt = $con->prepare("DELETE FROM $table WHERE $where");
    $stmt->execute();
    $count = $stmt->rowCount();
    if ($json == true) {
        if ($count > 0) {
            echo json_encode(array("status" => "success"));
        } else {
            echo json_encode(array("status" => "failure"));
        }
    }
    return $count;
}

function imageUpload($imageRequest)
{
    global $msgError;
    $imagename  = rand(1000, 10000) . $_FILES[$imageRequest]['name'];
    $imagetmp   = $_FILES[$imageRequest]['tmp_name'];
    $imagesize  = $_FILES[$imageRequest]['size'];
    $allowExt   = array("jpg", "png", "gif", "mp3", "pdf");
    $strToArray = explode(".", $imagename);
    $ext        = end($strToArray);
    $ext        = strtolower($ext);

    if (!empty($imagename) && !in_array($ext, $allowExt)) {
        $msgError = "EXT";
    }
    if ($imagesize > 2 * MB) {
        $msgError = "size";
    }
    if (empty($msgError)) {
        move_uploaded_file($imagetmp,  "../upload/" . $imagename);
        return $imagename;
    } else {
        return "fail";
    }
}



function deleteFile($dir, $imagename)
{
    if (file_exists($dir . "/" . $imagename)) {
        unlink($dir . "/" . $imagename);
    }
}

function checkAuthenticate()
{
    if (isset($_SERVER['PHP_AUTH_USER'])  && isset($_SERVER['PHP_AUTH_PW'])) {
        if ($_SERVER['PHP_AUTH_USER'] != "wael" ||  $_SERVER['PHP_AUTH_PW'] != "wael12345") {
            header('WWW-Authenticate: Basic realm="My Realm"');
            header('HTTP/1.0 401 Unauthorized');
            echo 'Page Not Found';
            exit;
        }
    } else {
        exit;
    }

    // End




}
function result($count)
{
    if ($count > 0) {
        printsuccess();
    } else {
        printfailure();
    }
}

function printfailure($message = "none")
{

    echo json_encode(array("status" => "failure", "message" => $message));
}


function printsuccess($message = "none")
{

    echo json_encode(array("status" => "success", "message" => $message));
}


function sendEmail($to, $title, $body)
{
    $header = "From: Company <Company@gmail.com>\r\n";

    if (!mail($to, $title, $body, $header)) {
        // Log the error or handle it
        echo "Email sending failed.";
        return false;
    }
    return true;
}




function getData($table, $where = null, $values = null,$json = true)
{
    global $con;
    $data = array();
    $stmt = $con->prepare("SELECT  * FROM $table WHERE   $where ");
    $stmt->execute($values);
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    $count  = $stmt->rowCount();
    if($json ==true){
    if ($count > 0) {
        echo json_encode(array("status" => "success", "data" => $data));
    } else {
        echo json_encode(array("status" => "failure"));
    }
} else{
    return $count;
}
  
}



function sendGCM($title, $message, $topic, $pageid, $pagename)
{
    // Your FCM server key
    $apiKey = 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCwUHYK5GexX9P2\n9st+16Y929gGkEYfWlSYc39VHyp+c4be3C33+mgLDm/Occq8/aVEznpL91Kkir3S\nbYid6uXsmclBWDkC5Wuc3KuG69tXAMv/03kwd0gyFKyd6SZ3ojv2w/P2fJ/GYca7\nNgl3d8u+c2fmC7rt8RpxT/vvTs7CWSYLOusYYJwZI1Kb2uMUU34wYdsEZ59mk7oM\nVmXXSYgPVC9sUpLk1fhkh2zMHTf2LQ2tY8K2ZggfPSazc99UBQ/pOjHy+ba5ygXQ\nFY7ihJjKlUbp/OF1Se5IH46TpPp7xd/Z5vw2ELoWtLXi/RUC/+QG7S/MgjPxmVu6\nX0frvMG3AgMBAAECggEAQk4f9jyrGjNVfTyWjp7+r6irdtxu4n+P7L0Sl6peyqsb\nf1gCGY2b7vyA43w7qBMjQdr8dvENrT9X33i9tdWOngm/e8l3tzUb4SPDhbvRAskT\n7qNSof1Zsyu/NqtlgfwK3OQYLQv08h/3IpRRvxHYF0lDO2oR5EWVkiNoNTjH3KIW\nMc0xi/mt9JkXywwO30uiFF5IF49uHBq7h8exRWPlxapMbHimMKTahs6YoVku0FpD\n2NZDfHlvTCtT2rITTj4zKqpzFJNIBdnksJbBsIKFTmCzdqobaVhNPSIGT/kG/PdY\nukKcQNWHhzlI+SJQYuSauUaYn5MbBM7XPBcCDzWN4QKBgQDX9bsmS/pjkNctyDoS\n3giq8sRKvKlln4t7diVZ0e15WXMyAz1LfgVP1W2NsNk3tI1GMCVLTYH6hfVYrfTJ\nwnpvhF3ZMzmY5JImlVCZxlqhydzC6uOsWfTaAYiRRFO/RcHQ2OPNdylYsZagjeYK\n8crJhtU4NUeedIagUNUUvKJHmQKBgQDRAQBYyAt1kGNyymfvPA/v2MDQBFtNdJdx\nz3lZ1GdOE4HdM9k8FkiYpkX7HFO5sPuz7eaxN3BSmAcNLLgBZLydhKYw6hBMcDcT\nszlE4/JlWIh3dJoBp6Td38PuBSO/JdRNT0vdtiOvH8PRSusGG4rs8aGoyuWh2Z+f\nO5sL1eHlzwKBgQDG24xwUEgJBKdPje8DzpZWq2Lamuy1Gft7PShZk/fC5P4xEFCR\nwkIr6BCQB0eNhuELv2un8n/8avuno88jNcQ+CbnNNeEUi2yUwKtOXhq4ncN9bIMn\nAlJ3qC/T7AHdv+MfZ4gke1SESkq0HtW0QD+F4HVX45/GJfCNkMEU7jnUCQKBgQCC\nK1587PJ+IRRfHQLIdB704YmMxPncbr4XywEoWmqQrQOXskAc9T/3mq9BKy5WG41Y\nTdX9D6ssNbVGllBvxb7XWBNtqYnHIaib42bKqjGAvzgXNg7o8vFyonfT2W2fEj98\neuOkTVlCK8V4p3FjF2paEk/94YhNWk3ZDXWOVIJh7wKBgQCByHvxN/KthiSJ6yKJ\nDfYdHNYRcd9PFiuanMLwxamMhgfSW8NXjmP6n0pUW7t3Nff3XsYNnWn+n4ZCp0Sv\nkw/9v4ZiSEoYv7BQNLm8pGb+RCqQAyXX9d7NnHghmzFnv0JUN0KXt0DQk/kX971Y\noVUDuJpEppbeXdbuyIXKW5yegQ==';  // Replace this with your actual Firebase Server Key

    $url = 'https://fcm.googleapis.com/fcm/send';

    $fields = array(
        "to" => '/topics/' . $topic,
        'priority' => 'high',
        'content_available' => true,
        'notification' => array(
            "body" => $message,
            "title" => $title,
            "click_action" => "FLUTTER_NOTIFICATION_CLICK",
            "sound" => "default"
        ),
        'data' => array(
            "pageid" => $pageid,
            "pagename" => $pagename
        )
    );

    $fields = json_encode($fields);

    $headers = array(
        'Authorization: key=' . $apiKey,  // Make sure to use your Firebase server key here
        'Content-Type: application/json'
    );

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);

    $result = curl_exec($ch);

    // Close cURL resource
    curl_close($ch);

    return $result;
}
function sendFCMNotification($title, $message, $topic)
{
    // Path to your service account credentials JSON file
    $serviceAccountJson = 'ecommerce-a01ac-ec954b63e656.json';  // Update this path to your service account JSON file

    // Load the credentials
    $credentials = json_decode(file_get_contents($serviceAccountJson), true);

    if (!$credentials) {
        echo "Error loading credentials file";  // Debug: Check if the credentials file is loaded
        return 'Error loading credentials';
    }

    // Get the private key and client email
    $privateKey = $credentials['private_key'];
    $clientEmail = $credentials['client_email'];

    // OAuth2 Token URL
    $tokenUrl = 'https://oauth2.googleapis.com/token';

    // Generate OAuth2 Token
    $token = generateOAuthToken($privateKey, $clientEmail, $tokenUrl);

    if (!$token) {
        echo "Error generating token";  // Debug: Check if the token generation fails
        return 'Error generating token';
    }

    echo 'Generated Token: ' . $token . "\n";  // Debug: Output generated token

    // FCM v1 endpoint URL
    $url = 'https://fcm.googleapis.com/v1/projects/' . $credentials['project_id'] . '/messages:send';

    // Prepare the message payload
    $fields = array(
        "message" => array(
            "topic" => $topic,
            "notification" => array(
                "title" => $title,
                "body" => $message,
                "click_action" => "FLUTTER_NOTIFICATION_CLICK",
                "sound" => "default"
            ),
            "data" => array(
                "pageid" => "some_page_id",
                "pagename" => "some_page_name"
            )
        )
    );

    $fields = json_encode($fields);

    // Set up HTTP headers with the Bearer token
    $headers = array(
        'Authorization: Bearer ' . $token,
        'Content-Type: application/json'
    );

    // cURL setup to send the request
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);

    // Execute cURL request and get the response
    $result = curl_exec($ch);

    if ($result === false) {
        echo 'cURL Error: ' . curl_error($ch);  // Debug: Show any cURL errors
    } else {
        echo 'cURL Result: ' . $result . "\n";  // Debug: Show the result of the cURL request
    }

    // Close cURL resource
    curl_close($ch);

    return $result;
}
function generateOAuthToken($privateKey, $clientEmail, $tokenUrl)
{
    // Create JWT payload
    $issuedAt = time();
    $expirationTime = $issuedAt + 3600;  // JWT expiration time (1 hour)

    $jwtHeader = base64_encode(json_encode(array(
        'alg' => 'RS256',
        'typ' => 'JWT'
    )));

    $jwtPayload = base64_encode(json_encode(array(
        'iss' => $clientEmail,
        'sub' => $clientEmail,
        'aud' => 'https://oauth2.googleapis.com/token',
        'iat' => $issuedAt,
        'exp' => $expirationTime,
        'scope' => 'https://www.googleapis.com/auth/firebase.messaging'  // Correct scope
    )));

    // Sign JWT with the private key
    $signedToken = signJWT($jwtHeader, $jwtPayload, $privateKey);

    // Prepare the JWT for requesting the access token
    $jwt = $jwtHeader . '.' . $jwtPayload . '.' . $signedToken;

    // Prepare the POST fields for token request
    $postData = array(
        'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion' => $jwt
    );

    // cURL to get the token
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $tokenUrl);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);

    // Get the response and parse the token
    $response = curl_exec($ch);
    curl_close($ch);

    if (!$response) {
        echo 'Error getting response from token request';
    }

    $responseArray = json_decode($response, true);
    return $responseArray['access_token'] ?? false;
}
function signJWT($header, $payload, $privateKey)
{
    // Decode the private key (remove newlines from key string)
    $privateKey = str_replace('\n', '', $privateKey);
    $privateKey = "-----BEGIN PRIVATE KEY-----\n" . chunk_split($privateKey, 64, "\n") . "-----END PRIVATE KEY-----";

    // Load the private key
    $privateKeyResource = openssl_get_privatekey($privateKey);

    if (!$privateKeyResource) {
        echo 'Error loading private key: ' . openssl_error_string();  // Debug: Show any OpenSSL errors
        return false;
    }

    // Create the signature
    $data = $header . '.' . $payload;
    $signature = '';
    if (!openssl_sign($data, $signature, $privateKeyResource, OPENSSL_ALGO_SHA256)) {
        echo 'Error signing JWT: ' . openssl_error_string();  // Debug: Show OpenSSL signing errors
        return false;
    }

    // Encode signature in base64
    return rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');
}


function insertNotify($title,$body,$userid,$pageid,$pagename ){
    global $con;
    $stmt = $con->prepare("INSERT INTO `notification`(`notification_title`, `notification_body`, `notification_userid`) VALUES (?,?,?)");
    $stmt->execute(array($title,$body,$userid));
$data=array("pageid"=>$pageid,"pagename"=>$pagename);
    sendNotificationToTopicwithcomposer($title, $body,"users$userid",$data);
  $count= $stmt->rowCount();
  if($count> 0){
  echo json_encode(array("status"=> "success"));
  }
  
}


require_once 'vendor/autoload.php'; // Ensure this path points to your Composer autoload file

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Kreait\Firebase\Exception\MessagingException;

function sendNotificationToTopicwithcomposer($title, $body, $topic, $data = []) {
    // Ensure the path is correct for your environment (in the same folder in this case)
    $serviceAccountPath = __DIR__ . '/ecommerce-a01ac-ec954b63e656.json';

    $factory = (new Factory)
        ->withServiceAccount($serviceAccountPath);
    
    $messaging = $factory->createMessaging();

    // Create the message
    $message = CloudMessage::withTarget('topic', $topic)
        ->withNotification(Notification::create($title, $body))
        ->withData($data);

    try {
        $response = $messaging->send($message);
        return $response;
    } catch (MessagingException $e) {
        return 'FCM send failed: ' . $e->getMessage();
    }
}






