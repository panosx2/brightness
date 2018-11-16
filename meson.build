    project('com.github.panosx2.brightness', 'vala', 'c')

    executable(
        meson.project_name(),
        'src/Dimmer.vala',
        dependencies: [
            dependency('gtk+-3.0')
        ],
        install: true
    )

    install_data(
        join_paths('data', meson.project_name() + '.desktop'),
        install_dir: join_paths(get_option('datadir'), 'applications')
    )

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
