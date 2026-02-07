#include-once
; Crypt.au3 - Versão mínima para AES-256 e SHA-1
; Autor original: Ward

Global Const $CALG_AES_256 = 0x00006610
Global Const $CALG_SHA1 = 0x00008004
Global Const $CALG_SHA256 = 0x0000800C

Func _Crypt_Startup()
    ; Placeholder - AutoIt já carrega crypto via DLL internamente
EndFunc

Func _Crypt_EncryptData($vData, $vPassword, $iAlgID)
    Local $hCryptProv, $hHash, $hKey, $vCryptData
    If Not _CryptAcquireContext($hCryptProv, "", 1, 1, 0) Then Return SetError(1, 0, "")
    If Not _CryptCreateHash($hCryptProv, $CALG_SHA1, 0, 0, $hHash) Then Return SetError(2, 0, "")
    If Not _CryptHashData($hHash, $vPassword, BinaryLen($vPassword), 0) Then Return SetError(3, 0, "")
    If Not _CryptDeriveKey($hCryptProv, $iAlgID, $hHash, 0, $hKey) Then Return SetError(4, 0, "")
    $vCryptData = _CryptEncrypt($hKey, 0, True, 0, $vData, BinaryLen($vData))
    _CryptDestroyKey($hKey)
    _CryptDestroyHash($hHash)
    _CryptReleaseContext($hCryptProv, 0)
    Return $vCryptData
EndFunc

Func _Crypt_DecryptData($vData, $vPassword, $iAlgID)
    Local $hCryptProv, $hHash, $hKey, $vPlainData
    If Not _CryptAcquireContext($hCryptProv, "", 1, 1, 0) Then Return SetError(1, 0, "")
    If Not _CryptCreateHash($hCryptProv, $CALG_SHA1, 0, 0, $hHash) Then Return SetError(2, 0, "")
    If Not _CryptHashData($hHash, $vPassword, BinaryLen($vPassword), 0) Then Return SetError(3, 0, "")
    If Not _CryptDeriveKey($hCryptProv, $iAlgID, $hHash, 0, $hKey) Then Return SetError(4, 0, "")
    $vPlainData = _CryptDecrypt($hKey, 0, True, 0, $vData, BinaryLen($vData))
    _CryptDestroyKey($hKey)
    _CryptDestroyHash($hHash)
    _CryptReleaseContext($hCryptProv, 0)
    Return $vPlainData
EndFunc

Func _Crypt_HashFile($sFile, $iAlgID)
    If Not FileExists($sFile) Then Return SetError(1, 0, "")
    Local $hFile = FileOpen($sFile, 16)
    If $hFile = -1 Then Return SetError(2, 0, "")
    Local $bData = FileRead($hFile)
    FileClose($hFile)
    Return _Crypt_HashData($bData, $iAlgID)
EndFunc

Func _Crypt_HashData($vData, $iAlgID)
    Local $hCryptProv, $hHash
    If Not _CryptAcquireContext($hCryptProv, "", 1, 1, 0) Then Return SetError(1, 0, "")
    If Not _CryptCreateHash($hCryptProv, $iAlgID, 0, 0, $hHash) Then Return SetError(2, 0, "")    If Not _CryptHashData($hHash, $vData, BinaryLen($vData), 0) Then Return SetError(3, 0, "")
    Local $iHashSize = DllStructCreate("dword")
    DllStructSetData($iHashSize, 1, 20)
    Local $pHash = DllStructCreate("byte[20]")
    If Not _CryptGetHashParam($hHash, 2, DllStructGetPtr($pHash), DllStructGetPtr($iHashSize), 0) Then Return SetError(4, 0, "")
    _CryptDestroyHash($hHash)
    _CryptReleaseContext($hCryptProv, 0)
    Return Hex(DllStructGetData($pHash, 1))
EndFunc

; Funções internas da CryptoAPI (DLL)
Func _CryptAcquireContext(ByRef $vProv, $sContainer, $iProvType, $iProv, $iFlags)
    Local $aRet = DllCall("Advapi32.dll", "bool", "CryptAcquireContextW", "handle*", 0, "wstr", $sContainer, "wstr", $iProv, "dword", $iProvType, "dword", $iFlags)
    If @error Or Not $aRet[0] Then Return False
    $vProv = $aRet[1]
    Return True
EndFunc

Func _CryptCreateHash($hProv, $iAlgID, $hKey, $iFlags, ByRef $vHash)
    Local $aRet = DllCall("Advapi32.dll", "bool", "CryptCreateHash", "handle", $hProv, "dword", $iAlgID, "handle", $hKey, "dword", $iFlags, "handle*", 0)
    If @error Or Not $aRet[0] Then Return False
    $vHash = $aRet[5]
    Return True
EndFunc

Func _CryptHashData($hHash, $vData, $iDataLen, $iFlags)
    Local $aRet = DllCall("Advapi32.dll", "bool", "CryptHashData", "handle", $hHash, "struct*", DllStructCreate("byte[" & $iDataLen & "]", $vData), "dword", $iDataLen, "dword", $iFlags)
    Return Not @error And $aRet[0]
EndFunc

Func _CryptDeriveKey($hProv, $iAlgID, $hHash, $iFlags, ByRef $vKey)
    Local $aRet = DllCall("Advapi32.dll", "bool", "CryptDeriveKey", "handle", $hProv, "dword", $iAlgID, "handle", $hHash, "dword", $iFlags, "handle*", 0)
    If @error Or Not $aRet[0] Then Return False
    $vKey = $aRet[5]
    Return True
EndFunc

Func _CryptEncrypt($hKey, $hHash, $bFinal, $iFlags, ByRef $vData, $iDataLen)
    Local $iBufLen = $iDataLen + 16 - Mod($iDataLen, 16)
    Local $tData = DllStructCreate("byte[" & $iBufLen & "]")
    DllStructSetData($tData, 1, $vData)
    Local $aRet = DllCall("Advapi32.dll", "bool", "CryptEncrypt", "handle", $hKey, "handle", $hHash, "bool", $bFinal, "dword", $iFlags, "struct*", DllStructGetPtr($tData), "dword*", $iDataLen, "dword", $iBufLen)
    If @error Or Not $aRet[0] Then Return SetError(1, 0, "")
    Return BinaryMid(DllStructGetData($tData, 1), 1, $aRet[6])
EndFunc

Func _CryptDecrypt($hKey, $hHash, $bFinal, $iFlags, ByRef $vData, $iDataLen)
    Local $tData = DllStructCreate("byte[" & $iDataLen & "]")
    DllStructSetData($tData, 1, $vData)
    Local $aRet = DllCall("Advapi32.dll", "bool", "CryptDecrypt", "handle", $hKey, "handle", $hHash, "bool", $bFinal, "dword", $iFlags, "struct*", DllStructGetPtr($tData), "dword*", $iDataLen)    If @error Or Not $aRet[0] Then Return SetError(1, 0, "")
    Return BinaryMid(DllStructGetData($tData, 1), 1, $aRet[6])
EndFunc

Func _CryptDestroyKey($hKey)
    DllCall("Advapi32.dll", "bool", "CryptDestroyKey", "handle", $hKey)
EndFunc

Func _CryptDestroyHash($hHash)
    DllCall("Advapi32.dll", "bool", "CryptDestroyHash", "handle", $hHash)
EndFunc

Func _CryptReleaseContext($hProv, $iFlags)
    DllCall("Advapi32.dll", "bool", "CryptReleaseContext", "handle", $hProv, "dword", $iFlags)
EndFunc

Func _CryptGetHashParam($hHash, $iParam, $pHash, $pHashLen, $iFlags)
    DllCall("Advapi32.dll", "bool", "CryptGetHashParam", "handle", $hHash, "dword", $iParam, "ptr", $pHash, "dword*", $pHashLen, "dword", $iFlags)
    Return Not @error
EndFunc
