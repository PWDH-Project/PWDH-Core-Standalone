package org.pwdhcore.qt;

import android.os.Bundle;
import android.system.ErrnoException;
import android.system.Os;

import org.qtproject.qt5.android.bindings.QtActivity;

import java.io.File;

public class BitcoinQtActivity extends QtActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        final File pwdhDir = new File(getFilesDir().getAbsolutePath() + "/.pwdh");
        if (!pwdhDir.exists()) {
            pwdhDir.mkdir();
        }

        super.onCreate(savedInstanceState);
    }
}
