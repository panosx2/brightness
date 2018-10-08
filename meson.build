#project name and programming language
    project('com.github.panosx2.brightness', 'vala', 'c')

    #Create a new executable, list the files we want to compile, list the dependencies we need, and install
    executable(
        meson.project_name(),
        'src/Brightness.vala',
        dependencies: [
            dependency('gtk+-3.0')
        ],
        install: true
    )

    #Install our .desktop file so the Applications Menu will see it
    install_data(
        join_paths('data', meson.project_name() + '.desktop'),
        install_dir: join_paths(get_option('datadir'), 'applications')
    )

    #Install our .appdata.xml file so AppCenter will see it
    install_data(
        join_paths('data', meson.project_name() + '.appdata.xml'),
        install_dir: join_paths(get_option('datadir'), 'metainfo')
    )

    icon_sizes = ['16', '24', '32', '48', '64', '128']

    foreach i : icon_sizes
        install_data(
            join_paths('icons', i, meson.project_name() + '.png'),
            install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
        )
    endforeach
