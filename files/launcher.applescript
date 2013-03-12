tell application "Terminal"
  #do script quoted form of POSIX path of (path to me) & "Contents/Resources/bin/gp '" & (name of me) & "'; sleep 1; exit"
  do script "ls " & quoted form of POSIX path of (path to me) & "; PariGP.app/Contents/Resources/bin/gp; sleep 5; exit"
end tell
