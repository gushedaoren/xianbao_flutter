package com.shumei.xianbao

import android.annotation.TargetApi
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor

import android.system.Os
import android.util.Log
import java.net.InetSocketAddress
import java.nio.ByteBuffer
import java.nio.channels.DatagramChannel

@TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
class MyVpnService : VpnService() {


    private var vpnInterface: ParcelFileDescriptor? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Start the VPN connection
        startVpnConnection()

        return START_STICKY
    }

    private fun startVpnConnection() {
        Log.d("MyVpnService", "startVpnConnection")
        Thread {
            try {
                val serverAddress = "114.115.141.160"
                val serverPort = 8888

                // Create a DatagramChannel for the VPN connection
                val vpnChannel = DatagramChannel.open()

                // Set the VPN channel non-blocking
                vpnChannel.configureBlocking(false)

                // Establish connection to the VPN server
                vpnChannel.connect(InetSocketAddress(serverAddress, serverPort))

                // Get the VPN interface file descriptor
                vpnInterface = configureVpnInterface()

                if(vpnInterface != null){
                    // Start the VPN interface
                    vpnInterface.let { vpnInterface ->
                        vpnChannel.let { vpnChannel ->
                            if (vpnInterface != null) {
                                startVpnInterface(vpnInterface, vpnChannel)
                            }
                        }
                    }
                }else{
                    print("vpnInterface is null")
                }



            } catch (e: Exception) {
                e.printStackTrace()
            }
        }.start()
    }

    private fun configureVpnInterface(): ParcelFileDescriptor? {
        // Configure the VPN interface and return the file descriptor
        // Implementation depends on your specific VPN requirements
        // Here you can set up VPN interface parameters such as address, MTU, routes, etc.
        // Refer to the Android VPN documentation for more details

        // For example:
        val builder = Builder()
        builder.addAddress("10.0.0.2", 32)
        builder.addRoute("0.0.0.0", 0)
        builder.setMtu(1500)
        builder.setSession("MyVPNService")

        val vpnInterface = builder.establish()
        if (vpnInterface == null) {
            throw IllegalStateException("Failed to establish VPN interface")
            return null
        }

        return vpnInterface
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startVpnInterface(vpnInterface: ParcelFileDescriptor, vpnChannel: DatagramChannel) {
        // Start handling VPN traffic
        // Here you can implement the logic to read packets from the VPN channel and send them to the VPN interface

        // For example:
        val buffer = ByteBuffer.allocate(Short.MAX_VALUE.toInt())

        while (true) {
            buffer.clear()
            val bytesRead = vpnChannel.read(buffer)
            if (bytesRead > 0) {
                // Process the received packet
                // For example, you can modify the packet and write it to the VPN interface
                // or send it to a remote server

                // Modify the buffer if needed

                // Write the modified packet to the VPN interface
                vpnInterface.fileDescriptor.let { fileDescriptor ->
                    try {
                        fileDescriptor?.let {

                            Os.write(fileDescriptor, buffer.array(), 0, bytesRead)
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()

        // Stop the VPN connection and release resources
        stopVpnConnection()
    }

    private fun stopVpnConnection() {
        // Close the VPN interface file descriptor
        vpnInterface?.close()

    }
}
