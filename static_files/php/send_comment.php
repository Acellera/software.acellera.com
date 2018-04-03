
<?php
$to	 = 'a.varela@acellera.com';
$subject = 'suggestion from software.acellera.com';
$message = $_POST["comment"];
$headers = 'From: '. $_POST["email"] . "\r\n" .
    'Reply-To: ' . $_POST["email"] . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

mail($to, $subject, $message, $headers);
echo 'Thanks for your feedback!. You are being redirected to the page you were using...';
try {
    header('refresh:2;url=' . $_SERVER['HTTP_REFERER']);
    die;
} catch (Exception $e) {
    echo '<br><br>Sorry, we could not track your page, you can click the arrow button to go back';
}

?>

