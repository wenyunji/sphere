import * as THREE from 'three'
import Experience from './Experience.js'
import vertexShader from '../Experience/shaders/vertax.glsl'
import fragmentShader from '../Experience/shaders/fragnent.glsl'
export default class Sphere {

    constructor() {

        this.experience = new Experience()
        this.debug = this.experience.debug
        this.scene = this.experience.scene
        this.time = this.experience.time

        if (this.debug) {
            this.debugFolder = this.debug.addFolder({
                title: 'Sphere',
                expanded: true
            })

            // this.debugFolder.addInput(
            //     this,
            //     'timeFrequency',
            //     { min: 0, max: 0.001, step: 0.000001 }
            // )
        }

        this.setGeometry()
        this.setMaterial()
        this.setMesh()
    }

    setGeometry() {
        this.geometry = new THREE.SphereGeometry(1, 512, 512)
        this.geometry.computeTangents()
        console.log( this.geometry)
    }

    setMaterial() {
        this.material = new THREE.ShaderMaterial({
            uniforms: {
                uDistortionFrequency: { value: 2.0 },
                uDistortionStrength: { value: 1.0 },
                uDisplacemenFrequency: { value: 2.0 },
                uDisplacemenStrength: { value: 0.2 },
                uTimeFrequency: { value: 0.0001 },
                uSubdivision: { value: new THREE.Vector2(this.geometry.parameters.widthSegments, this.geometry.parameters.heightSegments) },
                uTime: { value: 0 }
            },
            defines:{USE_TANGENT:''},
            vertexShader: vertexShader,
            fragmentShader: fragmentShader
        })

        if (this.debug) {
            this.debugFolder.addInput(
                this.material.uniforms.uDistortionFrequency,
                'value',
                { label: 'uDistortionFrequency', min: 0, max: 10, step: 0.001 },
            )

            this.debugFolder.addInput(
                this.material.uniforms.uDisplacemenFrequency,
                'value',
                { label: 'uDisplacemenFrequency', min: 0, max: 10, step: 0.001 },

            )

            this.debugFolder.addInput(
                this.material.uniforms.uDistortionStrength,
                'value',
                { label: 'uDistortionStrength', min: 0, max: 5, step: 0.001 },
            )

            this.debugFolder.addInput(
                this.material.uniforms.uDisplacemenStrength,
                'value',
                { label: 'uDisplacemenStrength', min: 0, max: 1, step: 0.001 },
            )

            this.debugFolder.addInput(
                this.material.uniforms.uTimeFrequency,
                'value',
                { label: 'uTimeFrequency', min: 0, max: 0.001, step: 0.00001 },

            )
        }

    }

    setMesh() {
        this.mesh = new THREE.Mesh(this.geometry, this.material)
        this.scene.add(this.mesh)
    }

    update() {
        this.material.uniforms.uTime.value = this.time.elapsed
    }

}