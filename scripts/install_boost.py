#!/usr/bin/env python

"""
Once the boost libraries are installed, use -DBOOST_ROOT=<PATH> to change
the boost root directory to link against the required library version.

TODO:
    * Toolchain specification on command line.
    * Any other flags to bootstrap or b2 to tweak the build

NOTE:
    * On Windows for version 1.69 below the script doesn't work. This is discussed below.
      https://stackoverflow.com/questions/42793958/building-boost-build-engine-cl-is-not-recognized-as-an-internal-or-external-co

      You need to use VS command line and manually execute bootstrap & build commands
"""

import argparse
import os, errno
import tempfile
import urllib.request
import tarfile
import subprocess
import shutil
from colorama import Fore, Style, init


def process(args):
    # retrive meta information from the provided arguments
    version, temp_dir, url, file_name = metainfo(args);

    # download boost from 'url' and store it in 'file_name'
    download(url, file_name)

    # extract boost to 'temp_dir'
    extract_directory = extract(temp_dir, file_name)

    if not args.download_only:
        # install
        prefix_arg = get_prefix(args.path, version)

        toolset = get_toolset(args.toolset)

        # run bootstrap
        bootstrap(prefix_arg, toolset, extract_directory)
        # run b2
        b2(prefix_arg, toolset, extract_directory)

        if not args.keep_download:
            remove_archive(file_name)
            remove_extract(extract_directory)


def metainfo(args):
    version_with_dots = args.version + '.0'
    version_with_underscore = version_with_dots.replace('.', '_')

    temp_dir = tempfile.gettempdir();
    print(Fore.GREEN + 'Temp directory: '.format(temp_dir), end='')
    print('{}'.format(temp_dir))

    # name of the boost archive
    archive_name = 'boost_' + version_with_underscore + '.tar.gz'

    # destination file name
    file_name = os.path.join(temp_dir, archive_name)

    # url to retrieve
    url = 'https://boostorg.jfrog.io/artifactory/main/release/' + \
            version_with_dots + '/source/' + archive_name

    return version_with_dots, temp_dir, url, file_name


def download(url, dest):
    print(Fore.GREEN + 'Downloading: ', end='')
    print('{} into {}'.format(url, dest))

    # https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
    # Download the file from `url` and save it locally under `dest`:
    with urllib.request.urlopen(url) as response, open(dest, 'wb') as out_file:
        data = response.read()
        out_file.write(data)


def extract(temp_dir, file_name):
    print(Fore.GREEN + 'Extracting: ', end='')
    dir_name = file_name.split('.')[0]
    print(dir_name)
    with tarfile.open(file_name) as tar:
        def is_within_directory(directory, target):
        	
        	abs_directory = os.path.abspath(directory)
        	abs_target = os.path.abspath(target)
        
        	prefix = os.path.commonprefix([abs_directory, abs_target])
        	
        	return prefix == abs_directory
        
        def safe_extract(tar, path=".", members=None, *, numeric_owner=False):
        
        	for member in tar.getmembers():
        		member_path = os.path.join(path, member.name)
        		if not is_within_directory(path, member_path):
        			raise Exception("Attempted Path Traversal in Tar File")
        
        	tar.extractall(path, members, numeric_owner=numeric_owner) 
        	
        
        safe_extract(tar, temp_dir)
    return os.path.join(temp_dir, dir_name)


def get_prefix(path, version):
    # If --prefix is not not given we default to sane paths.
    # If --prefix is not sane, Windows & Linux use C:\Boost & /usr/local
    # respectively.
    # But this doesn't *often* create version directory nicely under the BOOST_ROOT
    # directory. Therefore we need to do the following manipulation if the path
    # is not set.

    # Either way, when building with CMake provide -DBOOST_ROOT=<path> to change
    # the boost version aginst with the project is linked.
    if not path:
        if os.name == 'nt':
            path = r'C:\boost\boost_' + version
        else:
            root_path = os.path.join(os.path.expanduser("~"), ".local")
            path = str(root_path) + '/boost_' + version

    # Normalize path name by collapsing redundant seprators.
    prefix_path = os.path.normpath(path)

    # Print install path information.
    print(Fore.GREEN + 'Install path: ', end='')
    print('{}'.format(prefix_path))

    # Set up the whole prefix argument.
    # This is needed both in bootstrap and build procedure.
    return '--prefix=' + prefix_path

def get_toolset(toolset):
    if not toolset:
        if os.name == 'nt':
            toolset = 'msvc'
        else:
            toolset = 'gcc'

    return toolset

    # Print install path information.
    print(Fore.GREEN + 'Install path: ', end='')
    print('{}'.format(prefix_path))

    # Set up the whole prefix argument.
    # This is needed both in bootstrap and build procedure.
    return '--prefix=' + prefix_path

def bootstrap(prefix_arg, toolset, extract_directory):
    if os.name == 'nt':
        cmd = ['bootstrap.bat', '--with-toolset='+toolset]
    else:
        cmd = ['./bootstrap.sh', '--with-toolset='+toolset]

    cmd.append(prefix_arg)

    # Print bootstrap command
    print(Fore.GREEN + 'Bootstrap command: ', end='')
    print('{}'.format(' '.join(cmd)))

    subprocess.run(cmd, shell=False, cwd=extract_directory)


def b2(prefix_arg, toolset, extract_directory):
    if os.name == 'nt':
        cmd = ['b2.exe', 'toolset=' + toolset,  'install', prefix_arg, '-j 8']
    else:
        cmd = ['./b2', 'toolset=' + toolset, 'install', prefix_arg, '-j 8']

    # Print build command
    print(Fore.GREEN + 'Build command: ', end='')
    print('{}'.format(' '.join(cmd)))

    args = {'cwd': extract_directory}
    # Windows needs shell=True for some reason even though b2.exe is not a shell builtin
    if os.name == 'nt':
        args.update({'shell': True})
    else:
        args.update({'check': True})

    subprocess.run(cmd, **args)


def remove_archive(file_name):
    if os.path.exists(file_name):
        os.remove(file_name)


def remove_extract(extract_directory):
    if os.path.exists(extract_directory):
        try:
            if os.name == 'nt':
                # no issues of user permissions on Windows (I suppose)
                shutil.rmtree(extract_directory)
            else:
                cmd = ['rm', '-rf', extract_directory]
                print(Fore.GREEN + 'Extract directory remove command: ', end='')
                print('{}'.format(' '.join(cmd)))
                # don't change cwd, just execute the command from where we run the script
                subprocess.run(cmd)
        except:
            print(Fore.RED + 'Error happened while trying to remove the extract directory.')
            print(Fore.YELLOW + 'Please remove the extract directory manually: ', end='')
            print(extract_directory)


def main():
    parser = argparse.ArgumentParser(description='Install boost from source code')
    parser.add_argument('-v', '--version', required=True,
            help='Boost version to be installed')
    parser.add_argument('-t', '--toolset')
    parser.add_argument('-p', '--path',
            help='Installation path [C:\\boost\\boost_<ver> | /usr/local/boost_<ver>]')
    parser.add_argument('--keep-download', action='store_true',
            help='Keeps download archive after installing. Ignored if --keep-downloads is specified')
    parser.add_argument('--download-only', action='store_true',
            help='Downloads and extracts the archive witout installing')

    args = parser.parse_args()
    process(args)


if __name__ == '__main__':
    try:
        # Initialize colorama.
        # Automate sending reset sequences after each colored output.
        init(autoreset=True)
        main()

    except Exception as e:
        print('Error: ', end='')
        print(Fore.RED + '{}'.format(e))

